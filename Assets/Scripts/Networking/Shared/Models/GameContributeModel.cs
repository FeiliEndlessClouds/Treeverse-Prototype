public class GameContributeModel
{
	public int NetworkId { get; set; }
    public string PlayerName { get; set; }
    public int DamageDealt { get; set; }
    public int DamageMitigated { get; set; }
    public int Healed { get; set; }
    public ushort Death { get; set; }
    public ushort Killed { get; set; }

    public GameContributeModel()
	{
        NetworkId = -1;
        PlayerName = string.Empty;
        DamageDealt = 0;
        DamageMitigated = 0;
        Healed = 0;
        Death = 0;
        Killed = 0;
	}

    public void ResetRecords()
    {
        DamageDealt = 0;
        DamageMitigated = 0;
        Healed = 0;
        Death = 0;
        Killed = 0;
    }
}

