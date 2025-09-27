local WeightedRandom = {}

function WeightedRandom.Select(Items: {{Weight: number?}}, DefaultWeight: number?)
    assert(type(Items) == "table" and #Items > 0, "Items must be a non-empty table")

    local FallbackWeight = DefaultWeight or 1
    local TotalWeight = 0

    for _, Item in Items do
        assert(type(Item) == "table", "Each item must be a table")
        local ItemWeight = Item.Weight or FallbackWeight
        assert(type(ItemWeight) == "number" and ItemWeight > 0,
            "Weight must be a positive number")
        TotalWeight += ItemWeight
    end

    local Random = math.random() * TotalWeight
    local CurrentWeight = 0

    for Index, Item in Items do
        local ItemWeight = Item.Weight or FallbackWeight
        CurrentWeight += ItemWeight
        if Random <= CurrentWeight then
            return Index
        end
    end

    return #Items
end

return WeightedRandom