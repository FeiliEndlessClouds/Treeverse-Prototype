
using Postgrest.Attributes;
using Supabase;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Treeverse.Models
{
    [Table("items")]
    public class ItemModel : Postgrest.Models.BaseModel
    {
        [PrimaryKey("id", true)]
        public int Id { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("item_icon")]
        public string ItemIcon { get; set; }

        [Column("name")]
        public string ItemName { get; set; }
    }
}