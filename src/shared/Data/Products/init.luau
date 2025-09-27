--[[
    
    Created Tuesday, July 8th 2025, 9:36:51 pm
    RealEncryptal
    
--]]

local Products = {}

-- load children
for _, Product:ModuleScript in ipairs(script:GetChildren()) do
    Products[Product.Name] = require(Product)
end

shared.Products = Products

return Products