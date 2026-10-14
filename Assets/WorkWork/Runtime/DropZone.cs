using UnityEngine;
using UnityEngine.EventSystems;

namespace WorkWork
{
    public class DropZone : MonoBehaviour, IDropHandler
    {
        public GameController controller;
        public int slot = -1, equipmentSlot = -1;
        public bool hand, shop;
        public void OnDrop(PointerEventData e)
        {
            var token = DragToken.Current;
            if (token != null && token.controller == controller) controller.Drop(token, this);
        }
    }
}
