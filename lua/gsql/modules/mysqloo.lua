--[[----------------------------------------------------------
    gsql.mysqloo - MySQLOO module for gSQL
    - Based on MySQLOO module https://github.com/FredyH/MySQLOO -

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
    -- [database] MYSQLOO Database object
    connection = nil,
    -- [table][PreparedQuery] Prepared queries
    prepared = {},
    -- [number] Number of affected rows in the last query
    affectedRows = nil
}
local helpers = include('../helpers.lua')

function MODULE:init(dbhost, dbname, dbuser, dbpass, port, callback)
    --local connUID = util.CRC(dbhost .. dbname .. dbuser)

    --if Gsql.cache[connUID] then
       -- self.connection = Gsql.cache[connUID]
    --end
    -- Including the mysqloo driver
    local success, err = pcall(require, 'mysqloo')
    if not success then
        file.Append('gsql_logs.txt', '[gsql][new] : ' .. err)
        error('[gsql] A fatal error appenned while trying to include MySQLOO driver!')
    end
    -- Creating a new Database object
    self.connection = mysqloo.connect(dbhost, dbuser, dbpass, dbname, port)
    function self.connection:onConnected()
        callback(true, 'success', self)
    end
    function self.connection:onConnectionFailed(err)
        file.Append('gsql_logs.txt', '[gsql][new] : ' .. err)
        callback(false, 'err : ' .. err, nil)
    end

    if self.connection:status() ~= 0 and self.connection:status() ~= 1 then
        self.connection:connect()
    end
end

--- Set a new Query object and start the query
-- @param queryStr string : A SQL query string
-- @param callback function : Function that'll be called when the query finished
-- @param paramaters table : A table containing all (optionnal) parameters
-- @return void
function MODULE:query(queryStr, parameters, callback)
    for k, v in pairs(parameters) do
        if isstring(v) == 'string' then
            v = self.connection:escape(v)
        end
        queryStr = helpers.replace(queryStr, k, tostring(v))
    end
    local query = self.connection:query(queryStr) -- Doing the query
    query.onSuccess = function(query, data)
        self.affectedRows = query:affectedRows()
        callback(true, 'success', data, self.affectedRows)
    end
    query.onAborted = function(query)
        callback(false, 'aborted')
    end
    query.onError = function(query, err)
        file.Append('gsql_logs.txt', '[gsql][query] : ' .. err)
        callback(false, 'error : ' .. err)
    end
    query:start()
end

--- Add a new PreparedQuery object to the "prepared" table
-- @param queryStr string : A SQL query string
-- @return number : index of this object in the "prepared" table
-- @see gsql:execute
function MODULE:prepare(queryStr)
    self.prepared[#self.prepared + 1] = self.connection:prepare(queryStr)
    return #self.prepared
end

--- Delete a PreparedQuery object from the "prepared" table
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

--- Execute all prepared queries ordered by their index in the "prepared" table
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
    local i = 1
    for k, v in ipairs(parameters) do
        if isnumber(v) then -- Thanks Lua for the absence of a switch statement
            self.prepared[index]:setNumber(i, v)
        elseif isstring(v) then
            self.prepared[index]:setString(i, v)
        elseif isbool(v) then
            self.prepared[index]:setBool(i, v)
        elseif v == nil then
            self.prepared[index]:setNull(i)
        else
            file.Append('gsql_logs.txt', '[gsql][execute] : Invalid type of parameter (parameter : ' .. k .. ' value : ' .. v .. ')')
            error('[gsql] : An error appears while preparing the query. See the logs for more informations!')
            return false
        end
        i = i + 1
    end
    self.prepared[index].onSuccess = function (query, data)
        callback(true, 'success', data)
    end
    self.prepared[index].onAborted = function(query)
        callback(false, 'aborted')
    end
    self.prepared[index].onError = function(query, err)
        file.Append('gsql_logs.txt', '[gsql][execute] : ' .. err)
        callback(false, 'error')
    end
    self.prepared[index]:start()
end

return MODULE
