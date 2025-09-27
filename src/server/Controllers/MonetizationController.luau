--[[
    
    Created Tuesday, July 8th 2025, 9:47:20 pm
    RealEncryptal
    
--]]

local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local purchaseHistoryStore = DataStoreService:GetDataStore("PurchaseHistory")
local Players = game:GetService("Players")

local Controller = {
    Priority = 10,
    Signals = {},
}

local ProductData
function Controller:Init()
	ProductData = shared.Import "Products"
	
	-- Connect events
	MarketplaceService.PromptPurchaseFinished:Connect(Controller.PromptPurchaseFinished)
	MarketplaceService.ProcessReceipt = Controller.ProcessReciept

	Controller.ProductFunctions = {}

	for ProductName, ProductInfo in pairs(ProductData) do
		if ProductInfo.Type ~= Enum.InfoType.Product then continue end
		Controller.ProductFunctions[tostring(ProductInfo.AssetID)] = ProductInfo.Process or function () print("Process Function not Implemented!"); return true end
	end

	-- check for players that exist alr
	for _, Player in pairs(Players:GetPlayers()) do
		Controller.Signals.PlayerAdded(Player)
	end
end

-- Events
function Controller.ProcessReciept(receiptInfo)
	-- Check the data store to determine if the product was already granted
	local playerProductKey = receiptInfo.PurchaseId
	local purchased = false
	local success, result, errorMessage

	success, errorMessage = pcall(function()
		purchased = purchaseHistoryStore:GetAsync(playerProductKey)
	end)

	-- If the purchase is recorded, the product was already granted
	if success and purchased then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif not success then
		error("Data store error:" .. errorMessage)
	end

	-- Update the purchase record
	local success, isPurchaseRecorded = pcall(function()
		return purchaseHistoryStore:UpdateAsync(playerProductKey, function(alreadyPurchased)
			if alreadyPurchased then
				return true
			end

			-- Find the player who made the purchase in the server
			local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
			if not player then

				-- The player probably left the game
				-- If the player returns, the callback is called again
				return nil
			end

			local handler = Controller.ProductFunctions[tostring(receiptInfo.ProductId)]

			assert(handler, "Product not found: " .. tostring(receiptInfo.ProductId))

			local success, result = pcall(handler, receiptInfo, player)
			-- Do not record the purchase if granting the product failed
			if not success or not result then
				error("Failed to process a product purchase for ProductId: " .. tostring(receiptInfo.ProductId) .. " Player: " .. tostring(player) .. " Error: " .. tostring(result))
				return nil
			end

			-- Record the transaction in purchaseHistoryStore
			return true
		end)
	end)

	if not success then
		error("Failed to process receipt due to data store error.")
		return Enum.ProductPurchaseDecision.NotProcessedYet
	elseif isPurchaseRecorded == nil then

		-- Did not update the value in the data store
		return Enum.ProductPurchaseDecision.NotProcessedYet
	else

		-- IMPORTANT: Tell Roblox that the game successfully handled the purchase
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end

function Controller.PromptPurchaseFinished(Player:Player, AssetID, WasPurchased:boolean)
	if not WasPurchased then return false end

	local ProductData = Controller:GetProductFromID(AssetID)
	if not ProductData then return false end

	if ProductData.PlayerJoined then
		ProductData.PlayerJoined(Player)
	end
end

function Controller.Signals.PlayerAdded(Player)
	-- Check if player owns any products and run the PlayerJoined function
	for _, Product in pairs(ProductData) do
		if Product.Type ~= Enum.InfoType.GamePass then continue end
		
		local Success, IsOwned = pcall(function()
			return MarketplaceService:UserOwnsGamePassAsync(Player.UserId, Product.AssetID)
		end)

		if not Success then
			warn("Failed to check if player owns game pass: " .. Product.AssetID)
			continue
		end

		if IsOwned then
			Product.PlayerJoined(Player)
		end
	end
end

-- Methods
--function Controller:PromptPurchase(Player, Name)
--	local Product = ProductData[Name]
--
--	if not Product then
--		warn("[MonetizationController] Product not found: " .. Name)
--		return
--	end
--
--	return game.ReplicatedStorage.YoButt:InvokeClient(Player, Name)
--end

function Controller:GetProductData(Name)
	if not ProductData[Name] then
		warn("[MonetizationController] Product not found: " .. Name)
		return
	end

	return ProductData[Name]
end

function Controller:GetProductInfo(Name)
	local Product = ProductData[Name]

	if not Product then
		warn("[MonetizationController] Product not found: " .. Name)
		return
	end

	return MarketplaceService:GetProductInfo(Product.AssetID, Product.Type)
end

function Controller:GetProductFromID(AssetID)
	for _, Product in pairs(ProductData) do
		if Product.AssetID == AssetID then
			return Product
		end
	end

	warn("[MonetizationController] Product not found: " .. AssetID)
	return nil
end

return Controller