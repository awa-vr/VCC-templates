using UnityEditor;
using UnityEngine;

namespace AwAVR {
    [InitializeOnLoad]
    public static class PostProcessLayerImporter {
        const string LAYER_NAME = "PostProcessing";

        static PostProcessLayerImporter() {
            AddLayer(LAYER_NAME);
        }

        static void AddLayer(string layerName) {
            var tagManager = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/TagManager.asset")[0]);
            SerializedProperty layersProp = tagManager.FindProperty("layers");

            for (int i = 8; i < layersProp.arraySize; i++) {
                var currentLayer = layersProp.GetArrayElementAtIndex(i);
                if (currentLayer.stringValue == layerName) return;
                if (string.IsNullOrEmpty(currentLayer.stringValue)) {
                    currentLayer.stringValue = layerName;
                    tagManager.ApplyModifiedProperties();
                    Debug.Log($"Added layer '{layerName}'");
                    return;
                }
            }

            Debug.LogWarning($"Could not add layer '{layerName}': no empty slot.");
        }
    }
}