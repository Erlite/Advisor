--  > this allow you to call « gsql( ... ) » instead of « gsql:new( ... ) »

Gsql = Gsql or {}
setmetatable( Gsql, { __call = function( self, ... )
      return self:new( ... )
end } )
