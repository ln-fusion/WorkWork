using System;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using UnityEditor;
using UnityEngine;

namespace WorkWork.Editor
{
    // Project-local bootstrap; does not change the user's global Codex/Unity preferences.
    [InitializeOnLoad]
    public static class MvpEditorBridge
    {
        static bool attempted;
        static MvpEditorBridge() { EditorApplication.update += ConnectWhenReady; }
        static async void ConnectWhenReady()
        {
            if (attempted || Application.isBatchMode || EditorApplication.isCompiling || EditorApplication.isUpdating) return;
            attempted = true; EditorApplication.update -= ConnectWhenReady;
            try
            {
                var type = AppDomain.CurrentDomain.GetAssemblies().Select(a => a.GetType("MCPForUnity.Editor.Services.MCPServiceLocator")).FirstOrDefault(t => t != null);
                if (type == null) return;
                var bridge = type.GetProperty("Bridge", BindingFlags.Public | BindingFlags.Static).GetValue(null);
                bool started = await (Task<bool>)bridge.GetType().GetMethod("StartAsync").Invoke(bridge, null);
                Debug.Log("WORKWORK_MCP_CONNECTED=" + started);
            }
            catch (Exception ex) { Debug.LogWarning("WorkWork MCP connection: " + ex.Message); }
        }
    }
}
