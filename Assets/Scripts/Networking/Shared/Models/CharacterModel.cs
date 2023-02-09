using Postgrest.Attributes;
using Supabase;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Treeverse.Models
{
    [Table("characters")]
    public class CharacterModel : Postgrest.Models.BaseModel
    {
        // `ShouldInsert` Set to false so-as to honor DB generated key
        // If the primary key was set by the application, this could be omitted.
        [PrimaryKey("id", false)]
        public int Id { get; set; }

        [Column("name")]
        public string Name { get; set; }

        [Column("user_id")]
        public string UserId { get; set; }
    }
}