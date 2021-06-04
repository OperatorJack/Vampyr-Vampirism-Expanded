
local config = require("OperatorJack.Vampyr.config")

local logger = {}

logger.logLevels = {
    TRACE = 0,
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

local function log(level, module, info, str, ...)
        local prepend = ("[Vampyr.%s:%s:%s]:"):format(module, info.currentline, level)
        local aligned = ("%-36s"):format(prepend)
        mwse.log(aligned .. str, ...)
end

function logger.trace(str, ...)
    if doLog("TRACE") then
        local info = debug.getinfo(2, "Sl")
        local module = info.short_src:match("^.+\\(.+).lua$")
        log("TRACE", module, info, str, ...)
    end
end

function logger.debug(str, ...)
    if doLog("DEBUG") then
        local info = debug.getinfo(2, "Sl")
        local module = info.short_src:match("^.+\\(.+).lua$")
        log("DEBUG", module, info, str, ...)
    end
end

function logger.info(str, ...)
    if doLog("INFO") then
        local info = debug.getinfo(2, "Sl")
        local module = info.short_src:match("^.+\\(.+).lua$")
        log("INFO", module, info, str, ...)
    end
end

function logger.error(str, ...)
    if doLog("ERROR") then
        local info = debug.getinfo(2, "Sl")
        local module = info.short_src:match("^.+\\(.+).lua$")
        log("ERROR", module, info, str, ...)
    end
end

return logger