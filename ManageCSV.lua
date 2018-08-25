
local function manageCSV(file_path)
	local f = io.open(file_path,"r+")
	if f==nil then
        f:close()
		return print("open file error")
	end
	for i =1,3 do					--为获取单位行，先读前三行
		local csvLines = f:read()
	end
	local deletelow = {}                		
    local unitCSV_Line = string.sub(f:read(), 1, -2)..","  ----获得有单位这一属性行并去掉末尾换行符
    --print(unitCSV_Line)
	local low_1 = 1
	for val in string.gmatch(unitCSV_Line,"(.-)%,") do
        if (val=="") then
            table.insert(deletelow,low_1)  	--将无单位的列记录到deltelow中去
        end
        low_1 = low_1 + 1
    end                                    
	local fiveCSV_line =string.sub(f:read(), 1, -2)..","   --读第5行，为判断含PASS或空列做准备。
    --print(fiveCSV_line)
	local low_2 = 1
		for val in string.gmatch(fiveCSV_line,"(.-)%,") do
        if (val=="" or val =="PASS" or val == "--PASS--") then
            table.insert(deletelow,low_2)  	--将空列以及含”PASS“或”--PASS--“列记录到deltelow中去
        end
        low_2 = low_2 + 1
    end
    f:close()

    local no_repeatdeletelow = {}    
    for k,v in pairs(deletelow) do                --去重
    	no_repeatdeletelow[v] = 1
    end
    local new_no_repeatdeletelow={} 
  	for k,v in pairs(no_repeatdeletelow) do 
    table.insert(new_no_repeatdeletelow,k)               
  	end 
  	table.sort(new_no_repeatdeletelow)   --排序，得到需要删除的列
    --[[
    for i,v in pairs(new_no_repeatdeletelow) do
        print(v)
    end
    --]]
    local read_file = io.open(file_path,"r")
    local write_file = io.open(string.match(file_path, "(.+)/[^/]*%.%w+$").."/New_Test.csv","w")   
    for line in read_file:lines() do
        local read_line = string.sub(line, 1, -2).."," 
        --print(read_line)
        local write_line =""
        local read_line_tab = {}
        local write_line_tab = {}
        for val in string.gmatch(read_line,"(.-)%,") do
			table.insert(read_line_tab, val)
        end
        for i,v in pairs (new_no_repeatdeletelow) do 
        	table.remove(read_line_tab,v-i+1)
        end

        for i,v in pairs (read_line_tab)do 
        	write_line = write_line..v..","
        end
        --print(write_line)
        write_file:write(string.sub(write_line, 1, -2).."\n")  --去掉末尾","并添加换行
    end
    read_file:close()
    write_file:close()
end

manageCSV("/Users/apple/Desktop/4 常用LUA基础学习/test.csv")
