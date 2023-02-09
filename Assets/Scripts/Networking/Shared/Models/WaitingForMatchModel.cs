
using Postgrest.Attributes;
using Supabase;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Treeverse.Models
{
    [Table("waiting_for_match")]
    public class WaitingForMatchModel : Postgrest.Models.BaseModel
    {
        [PrimaryKey("user_id", true)]
        public string UserId { get; set; }

        [Column("player_count")]
        public int PlayerCount { get; set; }

        [Column("last_seen")]
        public DateTime LastSeen { get; set; }

        [PrimaryKey("match_found", true)]
        public string MatchFound { get; set; }
    }
}