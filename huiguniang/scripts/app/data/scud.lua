---- this is a lua lib to update create delete search data from files:


local scud = {}

function scud:readDataFromFiles(filename)
	-- body
	--print(filename);
	local file, e = io.open(filename, "w");
	--print(file);
	return file;
end

function scud:addData(filaname,data)

end

function scud:deleteData(filename,data)

end

function scud:updateData(filename,data)

end

return scud;