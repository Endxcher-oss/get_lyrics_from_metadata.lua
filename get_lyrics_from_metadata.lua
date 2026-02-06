local mp = require("mp")

local function set_lyrics(name, metadata)
    if type(metadata) ~= "nil" then
        lyrics = ""

        -- 在 metadata 表中提取歌词
        for key, value in pairs(metadata) do
            if type(key) == "string" and string.lower(key):find("^lyrics") then -- 匹配以 lyrics 开头的 key
                lyrics = value
            end
        end

        -- 将歌词写入文件
        local file = io.open(lyrics_file, "w+")
            if file then
                file:write(lyrics)
                file:close()
            end

        -- 执行添加歌词的命令
        local command = "sub-add "
        local final_command = command..lyrics_file
        mp.command(final_command)
    end
end

-- 构造存放歌词的文件
local temp = io.popen("id -u") -- 获取 uid
local uid = temp:read("*a")  -- 读取所有输出
temp:close()
lyrics_file = "/run/user/UID/mpv-lyrics"
uid = uid:gsub("%s+$", "") -- 去除 uid 后的换行符
lyrics_file = lyrics_file:gsub("UID", uid)

mp.observe_property("metadata", "native", set_lyrics)
mp.set_property("sub-pos", 50)
