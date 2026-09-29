import QtQuick
import qs.config

// M3 expressive slider: thick track with an inset icon and a thin handle.
Item {
    id: root

    property real value: 0          // 0..1
    property string icon
    property color accent: Theme.primary
    property color onAccent: Theme.primaryFg
    signal moved(real value)

    implicitHeight: 40
    implicitWidth: 200

    readonly property real visual: drag.pressed ? drag.live : value
    readonly property real handleX: Math.max(0, Math.min(width - 4, visual * width - 2))
    readonly property real gap: 6          // space between each track and the handle

    // Filled part: ends a gap before the handle and shrinks away near 0
    // (no minimum size, so it never pokes out behind the handle).
    readonly property real activeWidth: Math.max(0, handleX - gap)
    // The icon sits on the filled part only once that is wide enough to hold it.
    readonly property bool iconOnActive: activeWidth >= height

    Rectangle {
        id: active
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: root.activeWidth
        visible: width > 1
        radius: Math.min(height / 2, width / 2)
        color: root.accent
        Behavior on width { enabled: !drag.pressed; Anim { duration: Motion.duration.short } }
    }

    // Empty part: starts a gap after the handle.
    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height * 0.7
        width: Math.max(0, parent.width - root.handleX - 4 - root.gap)
        visible: width > 1
        radius: Math.min(height / 2, width / 2)
        color: Theme.surfaceHighest
        Behavior on width { enabled: !drag.pressed; Anim { duration: Motion.duration.short } }
    }

    Rectangle {
        x: root.handleX
        anchors.verticalCenter: parent.verticalCenter
        width: 4
        height: parent.height + 8
        radius: 2
        color: root.accent
        Behavior on x { enabled: !drag.pressed; Anim { duration: Motion.duration.short } }
    }

    // On the filled part it sits at the left edge; when the value is too low
    // for that, it moves onto the empty track just right of the handle.
    Icon {
        x: root.iconOnActive ? (root.height - size) / 2 : root.handleX + 4 + root.gap + (root.height * 0.7 - size) / 2
        anchors.verticalCenter: parent.verticalCenter
        text: root.icon
        size: 20
        fill: 1
        color: root.iconOnActive ? root.onAccent : Theme.surfaceVariantFg
        visible: root.icon !== "" && (root.iconOnActive || x + size < root.width)
        Behavior on color { ColorAnim { duration: Motion.duration.short } }
    }

    MouseArea {
        id: drag
        property real live: 0
        anchors.fill: parent
        anchors.margins: -4
        cursorShape: Qt.PointingHandCursor
        function update(x) {
            live = Math.max(0, Math.min(1, (x - 4) / root.width));
            root.moved(live);
        }
        onPressed: m => update(m.x)
        onPositionChanged: m => { if (pressed) update(m.x); }
        onWheel: w => root.moved(Math.max(0, Math.min(1, root.value + (w.angleDelta.y > 0 ? 0.05 : -0.05))))
    }
}
