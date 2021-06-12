--[[----------------------------------------------------------
    gsql - Facilitate SQL programming for GmodLua
    -- HELPERS FUNCTIONS --

    @author Gabriel Santamaria <gaby.santamaria@outlook.fr>

    Copyright 2019 Gabriel Santamaria

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

------------------------------------------------------------]]
local HELPERS = {}

--- Returns whether or not a module exists in the MODULE directory
-- @param name string : Module's name
-- @return bool
function HELPERS.moduleExists(name)
    local path = 'gsql/modules/'
    return file.Exists(path .. name .. '.lua', 'LUA') 
end

--- Helper function that replace parameters found in a string by the parameter itself.
-- @param queryStr string : the string that'll be affected by this function
-- @param name string : the name of the parameter which have to be found and replaced
-- @param value any : the value of the parameter
-- @return string : the new string, with parameters values instead of names
function HELPERS.replace(queryStr, name, value)
    local pattern = '{{' .. name .. '}}'
    if value == nil then
        value = 'NULL'
    elseif not isnumber(value) then
        value = '"' .. value .. '"'
    end
    return string.gsub(queryStr, pattern, value)
end

return HELPERS
