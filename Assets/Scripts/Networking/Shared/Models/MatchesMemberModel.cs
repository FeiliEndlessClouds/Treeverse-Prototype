
using Postgrest.Attributes;
using Supabase;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Treeverse.Models
{
    [Table("matches_member")]
    public class MatchesMemberModel : Postgrest.Models.BaseModel
    {
        [PrimaryKey("user_id", true)]
        public string UserId { get; set; }

        [Column("match_id")]
        public string MatchId { get; set; }

        [Column("last_seen")]
        public DateTime LastSeen { get; set; }

        [Column("loadout")]
        public int? Loadout { get; set; }

        [Column("name")]
        public string Name { get; set; }

        [Column("is_ready")]
        public bool IsReady { get; set; }

        [Column("team")]
        public int Team { get; set; }
    }
}