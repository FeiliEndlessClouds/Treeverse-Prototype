using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.Build.Reporting;

public class BuildScript
{
    [MenuItem("Build/Build Linux Dedicated Server")]
    public static void LinuxDedicatedServer()
    {
        var buildTarget = BuildTarget.StandaloneLinux64;
        EditorUserBuildSettings.SwitchActiveBuildTarget(targetGroup: BuildPipeline.GetBuildTargetGroup(platform: buildTarget), target: buildTarget);
        EditorUserBuildSettings.standaloneBuildSubtarget = StandaloneBuildSubtarget.Server;

        BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
        buildPlayerOptions.scenes = new[] { "Assets/Scenes/SampleScene.unity" };
        buildPlayerOptions.locationPathName = "LinuxBuildTeam1/LinuxServerBuild";
        buildPlayerOptions.target = buildTarget;
        //buildPlayerOptions.options = BuildOptions.EnableHeadlessMode | BuildOptions.DetailedBuildReport;
        buildPlayerOptions.subtarget = (int)StandaloneBuildSubtarget.Server;

        Console.WriteLine("Linux Dedicated Server.. building server");

        BuildPipeline.BuildPlayer(buildPlayerOptions);
        Console.WriteLine("Linux Dedicated Server.. building server done");
    }
}
