//using System.Threading.Tasks;
//using UnityEngine;
//using Supabase;
//using Supabase.Gotrue;
//using Supabase.Interfaces;
//using System.Collections.Generic;
//using Newtonsoft.Json;
//using Treeverse.Models;
//using Supabase.Realtime;
//using Postgrest.Models;

//public class AuthenticationManager : MonoBehaviour
//{
//    const string SUPABASE_URL = "https://vxgovbrvyzvsuwjkumng.supabase.co";
//    const string SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ4Z292YnJ2eXp2c3V3amt1bW5nIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzA2NTEwNjEsImV4cCI6MTk4NjIyNzA2MX0.sDUsK1UV6jVESrdoz7BSteRcuKZvlTAqquQxRL9FPK4";


//    static AuthenticationManager instance;

//    public static AuthenticationManager Instance
//    {
//        get
//        {
//            if (instance == null)
//            {
//                GameObject instanceObject = new GameObject("Authentication Manager");

//                instance = instanceObject.AddComponent<AuthenticationManager>();
//            }

//            return instance;
//        }
//    }

//    public class UnitySupabaseSessionHandler : ISupabaseSessionHandler
//    {
//        public Task<bool> SessionPersistor<TSession>(TSession session) where TSession : Session
//        {
//            PlayerPrefs.SetString("PLAYER_SESSION", JsonConvert.SerializeObject(session as Session));

//            PlayerPrefs.Save();

//            return Task.FromResult<bool>(true);
//        }

//        public Task<TSession?> SessionRetriever<TSession>() where TSession : Session
//        {
//            if (PlayerPrefs.GetString("PLAYER_SESSION") is string value && !string.IsNullOrEmpty(value))
//            {
//                return Task.FromResult<TSession>(JsonConvert.DeserializeObject<Session>(value) as TSession);
//            }

//            return Task.FromResult<TSession>(null);
//        }


//        public Task<bool> SessionDestroyer()
//        {
//            PlayerPrefs.DeleteKey("PLAYER_SESSION");

//            PlayerPrefs.Save();

//            return Task.FromResult<bool>(true);
//        }
//    }

//    private Supabase.Client m_SupabaseClient;
//    private Task m_InitializeTask;

//    private int m_SignedInCharacterId;

//    public string MatchId;

//    public bool HasCredentials
//    {
//        get { return PlayerPrefs.HasKey("USER_NAME") && PlayerPrefs.HasKey("USER_PASSWORD"); }
//    }

//    public bool IsSignedIn
//    {
//        get
//        {
//            return m_SupabaseClient.Auth.CurrentSession != null && m_SupabaseClient.Auth.CurrentUser != null;
//        }
//    }

//    public async Task<string> GetAccessToken()
//    {
//        await m_InitializeTask;

//#if UNITY_EDITOR
//        /* Automatic log-in on editor */
//        if (m_SupabaseClient.Auth.CurrentSession == null)
//        {
//            if (PlayerPrefs.HasKey("USER_NAME") && PlayerPrefs.HasKey("USER_PASSWORD"))
//            {
//                await m_SupabaseClient.Auth.SignInWithPassword(PlayerPrefs.GetString("USER_NAME"), PlayerPrefs.GetString("USER_PASSWORD"));
//            }
//            else
//            {
//                Debug.Log("You don`t have an account saved on PlayerPrefs to play without authentication!");
//            }
//        }
//#endif

//        return m_SupabaseClient.Auth.CurrentSession.AccessToken;
//    }

//    public async Task<ISupabaseTable<T, Channel>> GetSupabaseTable<T>() where T : BaseModel, new()
//    {
//        await m_InitializeTask;

//        return m_SupabaseClient.From<T>();
//    }

//    public async Task<List<CharacterModel>> GetCharactersAsync()
//    {
//        var response = await m_SupabaseClient.From<CharacterModel>()
//            .Get();

//        return response.Models;          
//    }

//    public int GetCharacterId()
//    {
//        if(m_SignedInCharacterId == 0)
//        {
//            m_SignedInCharacterId = PlayerPrefs.GetInt("AUTO_SIGN_IN_CHARACTER_ID", 0);
//        }

//        return m_SignedInCharacterId;
//    }

//    public async Task CreateCharacterAsync(string name)
//    {
//        await m_InitializeTask;

//        var response = await m_SupabaseClient.Postgrest.Rpc("create_character", new Dictionary<string, object>()
//        {
//            {"name", name }
//        });
//    }

//    public async Task CallRpc(string name, Dictionary<string, object> args)
//    {
//        await m_InitializeTask;

//        await m_SupabaseClient.Postgrest.Rpc(name, args);
//    }

//    public async Task<Session> SignInAsync(string email, string password, bool rememberMe = true)
//    {
//        await m_InitializeTask;

//        if (rememberMe)
//        {
//            PlayerPrefs.SetString("USER_NAME", email);
//            PlayerPrefs.SetString("USER_PASSWORD", password);

//            PlayerPrefs.Save();
//        }

//        var session = await m_SupabaseClient.Auth.SignInWithPassword(email, password);

//        return session;
//    }

//    public async Task<Session> SignUpAsync(string email, string password)
//    {
//        await m_InitializeTask;

//        var session = await m_SupabaseClient.Auth.SignUp(email, password);

//        return session;

//    }

//    public async Task<Supabase.Client> GetClientAsync()
//    {
//        await m_InitializeTask;

//        return m_SupabaseClient;
//    }

//    public async Task SignOutAsync()
//    {
//        await m_InitializeTask;

//        PlayerPrefs.DeleteKey("USER_NAME");
//        PlayerPrefs.DeleteKey("USER_PASSWORD");

//        PlayerPrefs.Save();

//        await m_SupabaseClient.Auth.SignOut();
//    }

//    void Awake()
//    {
//        DontDestroyOnLoad(this);

//        m_SupabaseClient = new Supabase.Client(SUPABASE_URL, SUPABASE_ANON_KEY, new SupabaseOptions
//        {
//            AutoConnectRealtime = true,
//            PersistSession = true,
//            AutoRefreshToken = true,
//            SessionHandler = new UnitySupabaseSessionHandler()
//        });

//        m_InitializeTask = m_SupabaseClient.InitializeAsync();
//    }
//}
