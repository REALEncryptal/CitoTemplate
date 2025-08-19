--[[
    
    Created Friday, July 18th 2025, 5:57:51 pm
    RealEncryptal
    
--]]

local function formatNumber(n)
	if n == 0 then
		return "FREE"
	end

	local isNegative = n < 0
	n = math.abs(n)

	local suffixes = {
		{1e15, "Q"}, -- Quadrillion
		{1e12, "T"}, -- Trillion
		{1e9,  "B"}, -- Billion
		{1e6,  "M"}, -- Million
		{1e3,  "k"}, -- Thousand
	}

	for i, s in ipairs(suffixes) do
		local value, suffix = s[1], s[2]
		if n >= value then
			local formatted = n / value

			-- Rollover check
			if formatted >= 999.5 and i > 1 then
				local nextValue, nextSuffix = suffixes[i - 1][1], suffixes[i - 1][2]
				formatted = n / nextValue
				suffix = nextSuffix
			end

			local str
			if formatted >= 100 then
				str = string.format("%.0f", formatted)
			elseif formatted >= 10 then
				str = string.format("%.1f", formatted)
			else
				str = string.format("%.2f", formatted)
			end

			-- Strip trailing zeros
			str = string.gsub(str, "%.0+$", "")
			str = string.gsub(str, "(%..-)0+$", "%1")

			if isNegative then
				str = "-" .. str
			end

			return str .. suffix
		end
	end

	-- Plain numbers under 1k
	return isNegative and "-" .. tostring(n) or tostring(n)
end

if true then return formatNumber end -- dont run tests

local testCases = {
	{input = 0, expected = "FREE"},
	{input = -1, expected = "-1"},
	{input = 100, expected = "100"},
	{input = 999, expected = "999"},
	{input = 1000, expected = "1k"},
	{input = 1500, expected = "1.5k"},
	{input = 1560, expected = "1.56k"},
	{input = 9999, expected = "10k"},
	{input = 10000, expected = "10k"},
	{input = 12540, expected = "12.5k"},
	{input = 12599, expected = "12.6k"},
	{input = 999999, expected = "1M"},
	{input = 1000000, expected = "1M"},
	{input = 1200000, expected = "1.2M"},
	{input = 999999999, expected = "1B"},
	{input = 1e9, expected = "1B"},
	{input = 1.5e9, expected = "1.5B"},
	{input = 1e12, expected = "1T"},
	{input = 1e15, expected = "1Q"},
	{input = 999999999999999, expected = "1Q"},
	{input = 1e14, expected = "100T"},
	{input = 1e13, expected = "10T"},
	{input = 100000, expected = "100k"},
	{input = 10000000, expected = "10M"},
	{input = -100, expected = "-100"},
	{input = -1000, expected = "-1k"},
	{input = -999999, expected = "-1M"},
	{input = -1e9, expected = "-1B"},
	{input = -1e15, expected = "-1Q"},
}

-- Run tests
local passed = 0

for i, test in ipairs(testCases) do
	local actual = formatNumber(test.input)
	if actual == test.expected then
		print("✅ Test " .. i .. " passed:\t" .. test.input .. "\t->\t" .. actual)
		passed = passed + 1
	else
		warn("❌ Test " .. i .. " failed:\t" .. test.input .. "\tExpected:\t" .. test.expected .. "\tGot:\t" .. actual)
	end
end

print("----------")
print("Passed", passed, "out of", #testCases, "tests.")