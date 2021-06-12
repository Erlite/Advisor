local tbl = 
{
    name = "Replicate",
    description = "A high-performance library for reading and writing tables.",
    loadOrder = 
    {
        "sh_replicate_assert.lua",
        "sh_rep_property.lua",
        "sh_replication_template.lua",
        "sh_replicate.lua"
    }
}

return Module(tbl)