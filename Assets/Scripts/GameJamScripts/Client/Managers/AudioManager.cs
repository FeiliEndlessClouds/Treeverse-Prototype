using UnityEngine;
using System.Collections;
using UnityEngine.Audio;

public enum MusicNames
{
    BGM_Situation_Defense,  // Defense_Base
    BGM_Situation_Tension,    // Defense_Battle
    BGM_Boss_Skeleton,      // Attack
    BGM_SkyRuin_ResultScreen,       // Select characters, Result screen.
    EndResultMusic,
    COUNT,
    NULL = 999
}

public enum Sounds
{
	NewLogEntry,
    MatchEnd,
    PlayerFootStep,
    ShieldBash,
    Heal,
    PlayerOuch,
    BladeSwing,
    TurnInvisible,
    TreePlanted_Attackers,
    TreePlanted_Defenders,
    SwitchSide,
    SeedHit,
    PlayerDeath,
    TreeScore,
    ThrowSeed,
    ArmorUp,
    BowShot,
    BowShotHit,
    TreeExplode,
    Ass1,
    Ass2,
    Ass3,
    Bar1,
    Bar2,
    Bar3,
    Pal1,
    Pal2,
    Pal3,
    Ran1,
    Ran2,
    Ran3,
    Taunt,
    Lose,
    Win,
    COUNT,
    NULL = 99999999
}

public class AudioManager : MonoBehaviour
{
    public float musicVol = 1f;
	public AudioSource musicA;
    public AudioSource musicB;
    public AnimationCurve fadeInCurve;

    public enum crossFadingStates
    {
        NONE,
        ATOB,
        BTOA
    }
    public crossFadingStates doCrossFadeMusic = crossFadingStates.NONE;
    private float fadeSpeed = 1f;
    public bool bPlayingA = true;
    private MusicNames playedMusic;
    public AudioClip[] sound;

    private int[] playedSoundCount;

    void Awake()
	{
        playedSoundCount = new int[(int)Sounds.COUNT];
    }

    public void FlushPlayedMusic()
    {
        playedMusic = MusicNames.NULL;
    }

    public void StartMusic(MusicNames nextMusic, bool bCut, bool bLoop)
    {
        if (playedMusic == nextMusic)
        {
            Debug.LogWarning("The music you want to start is the same as the one that is already playing.");
            return;
        }

        // Init
        //musicA.loop = false;
        //musicB.loop = false;
        playedMusic = nextMusic;

        // Start music
        if (bPlayingA)
        {
            musicB.clip = Resources.Load<AudioClip>("Musics/" + nextMusic.ToString());
            musicB.loop = bLoop;
            doCrossFadeMusic = crossFadingStates.ATOB;
            if (bCut)
            {
                musicB.volume = 1f;
                musicA.volume = 0f;
            }
            bPlayingA = false;

            if (!musicB.isPlaying)
                musicB.Play();
        }
        else
        {
            musicA.clip = Resources.Load<AudioClip>("Musics/" + nextMusic.ToString());
            musicA.loop = bLoop;
            doCrossFadeMusic = crossFadingStates.BTOA;
            if (bCut)
            {
                musicB.volume = 0f;
                musicA.volume = 1f;
            }
            bPlayingA = true;

            if (!musicA.isPlaying)
                musicA.Play();
        }
    }

    void Update()
    {
        if (doCrossFadeMusic != crossFadingStates.NONE)
        {
            if (doCrossFadeMusic == crossFadingStates.ATOB)
            {
                if (musicB.clip != null)
                {
                    if (musicA.volume > 0.0f)
                    {
                        musicA.volume -= Time.unscaledDeltaTime * fadeSpeed;
                        musicB.volume += Time.unscaledDeltaTime * fadeSpeed;
                    }
                    else
                    {
                        musicA.volume = 0.001f;
                        musicB.volume = 1f;

                        doCrossFadeMusic = crossFadingStates.NONE;
                    }
                }
            }
            else if (doCrossFadeMusic == crossFadingStates.BTOA)
            {
                if (musicA.clip != null)
                {
                    if (musicB.volume > 0.0f)
                    {
                        musicB.volume -= Time.unscaledDeltaTime * fadeSpeed;
                        musicA.volume += Time.unscaledDeltaTime * fadeSpeed;
                    }
                    else
                    {
                        musicB.volume = 0.001f;
                        musicA.volume = 1f;

                        doCrossFadeMusic = crossFadingStates.NONE;
                    }
                }
            }
        }
    }

    public void Play3DSound(Sounds soundName, Transform target)
    {
        StartCoroutine(Play3DSoundC(soundName, target));
    }
    IEnumerator Play3DSoundC(Sounds soundName, Transform target)
    {
        GameObject audioSourceGO = new GameObject();
        audioSourceGO.transform.position = target.transform.position;
        AudioSource source = audioSourceGO.AddComponent<AudioSource>();
        source.volume = 0.5f;
        source.spatialBlend = 1.0f;
        //source.minDistance = 3;
        source.clip = sound[(int)soundName];
        source.Play();

        while (source.isPlaying)
            yield return null;

        Destroy(audioSourceGO);

        yield return null;
    }

    public void PlaySound(Sounds soundName, bool bRandomPitch)
    {
        StartCoroutine(Play2DSound(soundName, 0.5f, bRandomPitch));
    }
    public void PlaySound(Sounds soundName)
	{
        StartCoroutine(Play2DSound(soundName, 0.5f, false));
    }
    public void PlaySound(Sounds soundName, float vol, bool bRandomPitch)
    {
        StartCoroutine(Play2DSound(soundName, vol, bRandomPitch));
    }
    public void PlaySound(Sounds soundName, float vol)
    {
        StartCoroutine(Play2DSound(soundName, vol, false));
    }
    private IEnumerator Play2DSound(Sounds soundName, float vol, bool bRandomPitch)
    {
        playedSoundCount[(int)soundName]++;

        bool bPrioritized = false;

        int soundCountLimit = 4;
        if (!bPrioritized)
        {
            if (playedSoundCount[(int)soundName] > soundCountLimit)
                yield return null;
        }

        if (playedSoundCount[(int)soundName] > soundCountLimit + 1)
        {
            playedSoundCount[(int)soundName]--;
            yield break;
        }

        AudioSource source = gameObject.AddComponent<AudioSource>();
        source.clip = sound[(int)soundName];
        source.spatialBlend = 0.0f;
        source.volume = vol;
        source.pitch = bRandomPitch ? Random.Range(0.5f, 1.5f) : 1f;
        source.Play();

        while (source.isPlaying)
            yield return null;

        playedSoundCount[(int)soundName]--;
        Destroy(source);
    }
}
