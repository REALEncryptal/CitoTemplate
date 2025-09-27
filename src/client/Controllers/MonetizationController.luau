--[[
    
    Created Tuesday, July 8th 2025, 9:31:50 pm
    RealEncryptal
    
--]]

local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Controller = {
	Priority = 10
}

local ProductData
function Controller:Init()
	ProductData = shared.Import "Products"
end

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

function Controller:PromptPurchase(Name:string)
	local Product = ProductData[Name]

    if not Product then
        warn("[MonetizationController] Product not found: " .. Name)
        return
    end

	if Product.Type == Enum.InfoType.GamePass then
		MarketplaceService:PromptGamePassPurchase(LocalPlayer, Product.AssetID)
	else
		MarketplaceService:PromptProductPurchase(LocalPlayer, Product.AssetID)
	end
end

return Controller