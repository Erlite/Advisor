--[[----------------------------------------------------------
    gsql.tmysql - tMySQL4 module for gSQL
    - Based on tMySQL4 module https://github.com/bkacjios/gm_tmysql4 -

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
local MODULE = {
    -- [Database] The Database connection object
    connection = nil,
    -- [number] Number of affected rows in the last query
    affectedRows = nil,
    -- [table][string] "Prepared" queries strings will be stored here
    prepared = {}
}

local helpers = include('../helpers.lua')

function MODULE:init(dbhost, dbname, dbuser, dbpass, port, callback)
    --local connUID = util.CRC(dbhost .. dbname .. dbuser)

    --if Gsql.cache[connUID] then
        --self.connection = Gsql.cache[connUID]
    --end
    -- Including the tmysql4 driver
    local success, err = pcall(require, 'tmysql4')
    if not success then
        file.Append('gsql_logs.txt', '[gsql][new] : ' .. err)
        error('[gsql] A fatal error appenned while trying to include tMySQL4 driver!')
    end
    -- Creating a new Database object
    self.connection, err = tmysql.initialize(dbhost, dbuser, dbpass, dbname, port or 3306, nil, CLIENT_MULTI_STATEMENTS)
    if err then
        file.Append('gsql_logs.txt', '[gsql][new] : ' .. err)
        callback(false, 'err : ' .. err, nil)
        return
    end
    -- Gsql.cache[connUID] = self.connection

    callback(true, 'success', self)
end

--- Starts a new query with the existing connection
-- @param queryStr string : A SQL query string
-- @param callback function : Function that'll be called when the query finished
-- @param paramaters table : A table containing all (optionnal) parameters
-- @return void
function MODULE:query(queryStr, parameters, callback)
    if (queryStr == nil) then error('[gsql][query] An error occured while trying to query : Argument \'queryStr\' is missing!') end
    parameters = parameters or {}
    -- By using this instead of a table in string.gsub, we avoid nil-related errors
    for k, v in pairs(parameters) do
        if isstring(v) == 'string' then
            v = self.connection:Escape(v)
        end
        queryStr = helpers.replace(queryStr, k, tostring(v))
    end

    local query = self.connection:Query(queryStr, function (result)
        if not result[1].status then
            file.Append('gsql_logs.txt', '[gsql][query] : ' .. result[1].error)
            callback(false, 'error : ' .. result[1].error)
            return
        end
        self.affectedRows = result[1].affected
        callback(true, 'success', result[1].data, self.affectedRows)
    end)
end

--- Add a new prepared query string to the prepared table
-- @param queryStr string : A SQL query string
-- @return number : index of this object in the "prepared" table
-- @see gsql:execute
function MODULE:prepare(queryStr)
    self.prepared[#self.prepared + 1] = queryStr
    return #self.prepared
end

--- Delete a prepared query string from the prepared table
-- @param index number : index of this object in the "prepared" table
-- @return bool : the status of this deletion
function MODULE:delete(index)
    if not self.prepared[index] then -- Checking if the index is correct
        file.Append('gsql_logs.txt', '[gsql][delete] : Invalid \'index\'. Requested deletion of prepared query number ' .. index .. ' as failed. Prepared query doesn\'t exist')
        error('[gsql] An error occured while trying to delete a prepared query! See logs for more informations')
        return false
    end
    -- Setting the PreparedQuery object to nil
    self.prepared[index] = nil
    return true
end

--- Bind every parameters of an SQL string
-- @param sql string
-- @param parameters table
-- @return string : the SQL string with binded parameters
local function bindParams(sqlstr, parameters)
    for k, v in pairs(parameters) do
        if v == nil then
            v = 'NULL'
        elseif not isnumber(v) then
            v = MODULE.connection:Escape(v)
            v = '"' .. v .. '"'
        end
        sqlstr = string.gsub(sqlstr, '?', v, 1)
    end
    return sqlstr
end

--- Execute a specific prepared query string from the prepared table, identified by its index
-- Call the callback function when it finished
-- @param index number : index of this object in the "prepared" table
-- @param callback function : function called when the PreparedQuery finished
-- @param parameters table : table of all parameters that'll be added to the prepared query
-- @return void
function MODULE:execute(index, parameters, callback)
    if not self.prepared[index] then -- Checking if the index is correct
        file.Append('gsql_logs.txt', '[gsql][execute] : Invalid \'index\'. Requested deletion of prepared query number ' .. index .. ' as failed. Prepared query doesn\'t exist')
        error('[gsql] An error occured while trying to execute a prepared query! See logs for more informations')
        return false
    end
    local sqlStr = bindParams(self.prepared[index], parameters)
    self:query(sqlStr, {}, callback)
end

return MODULE
