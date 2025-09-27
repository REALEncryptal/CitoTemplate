local Constants = {}

---------

-- ProfileController
Constants.PROFILE_TEMPLATE = {}
Constants.PROFILE_LEADERSTATS = {}
Constants.PROFILE_SAVE = true   -- Load data?





---------


--[[
    @function Constants:Debug
    Prints a message if DEBUG is enabled
    @param ... any - Arguments to print
]]
function Constants:Debug(...)
    if not Constants.DEBUG then return end
    print(...)
end

--[[
    @function Constants:DebugFunction
    Calls a function if DEBUG is enabled
    @param Function function - The function to call
    @param ... any - Arguments to pass to the function
]]
function Constants:DebugFunction(Function, ...)
    if not Constants.DEBUG then return end
    Function(...)
end


return Constants