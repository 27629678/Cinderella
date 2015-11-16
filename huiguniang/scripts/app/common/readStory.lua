--require("config");
--local json = require("json")

module("readStory")

function testJson()

    --local filepath = "app/data/1/Config.txt";
    --local content = readAll(filepath);
    --print(content);

    -- Object to JSON encode
    --print(package.path);

    test = {
      one='first',two='second',three={2,3,5}
    }

    jsonTest = json.encode(test)

    print('JSON encoded test is: ' .. jsonTest)

    -- Now JSON decode the json string
    result = json.decode(jsonTest)

    print ("The decoded table result:")
    table.foreach(result,print)
    print ("The decoded table result.three")
    table.foreach(result.three, print)
end

function readAll(file)
    local f = io.open(file, "r")
    local content = ""
    local length = 0

    while f:read(0) ~= "" do
        local current = f:read("*all")

        print(#current, length)
        length = length + #current

        content = content .. current
    end

    return content
end