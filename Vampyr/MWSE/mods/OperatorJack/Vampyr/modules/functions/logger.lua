
local config = require("OperatorJack.Vampyr.config")

local logger = {}

logger.logLevels = {
    DEBUG = 1,
    INFO = 2,
    ERROR = 3,
    NONE = 4
}

--[[
    Checks if the current log level is high enough to log the message
]]
local function doLog(logLevel)
    return logger.logLevels[config.logLevel] <= logger.logLevels[logLevel]
end

local function log(level, str, ...)
        local info = debug.getinfo(2, "Sl")
        local module = info.short_src:match("^.+\\(.+).lua$")
        local prepend = ("[Vampyr.%s:%s:%s]:"):format(module, info.currentline, level)
        local aligned = ("%-36s"):format(prepend)
        mwse.log(aligned .. str, ...)
end

function logger.debug(str, ...)
    if doLog("DEBUG") then
       log("DEBUG",  str, ...)
    end
end

function logger.info(str, ...)
    if doLog("INFO") then
       log("INFO",  str, ...)
    end
end

function logger.error(str, ...)
    if doLog("ERROR") then
       log("ERROR",  str, ...)
    end
end

return logger