
using Postgrest.Attributes;
using Supabase;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Treeverse.Models
{
    [Table("matches")]
    public class MatchModel : Postgrest.Models.BaseModel
    {
        // `ShouldInsert` Set to false so-as to honor DB generated key
        // If the primary key was set by the application, this could be omitted.
        [PrimaryKey("id", false)]
        public string Id { get; set; }

        [Column("status")]
        public string Status { get; set; }

        [Column("team1_members")]
        public string[] Team1Members { get; set; }

        [Column("team2_members")]
        public string[] Team2Members { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("finished_at")]
        public DateTime FinishedAt { get; set; }

        [Column("is_ready")]
        public bool IsReady { get; set; }
    }
}