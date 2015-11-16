require("persistence");
scud = require("scud");
--[[
t_original = {1, 2, ["a"] = "string", b = "test", {"subtable", [4] = 2}};
testStore = {1,2};
persistence.store("storage.lua", t_original);
persistence.store("storage.lua", testStore);
t_restored = persistence.load("storage.lua");
]]--
t_restored = scud:readDataFromFiles("storage.lua");
print(t_restored);