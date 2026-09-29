import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services

// Wallpaper layer with a cross-fade between images. Without a wallpaper a
// gradient built from the current scheme is shown instead.
PanelWindow {
    id: root

    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    color: Theme.surfaceDim
    WlrLayershell.namespace: "rice-wallpaper"
    WlrLayershell.layer: WlrLayer.Background

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0; color: Theme.primaryContainer }
            GradientStop { position: 1; color: Theme.surfaceDim }
        }
    }

    property Image front: a

    Connections {
        target: Wallpapers
        function onCurrentChanged() { root.swap(); }
    }
    Component.onCompleted: swap()

    function swap() {
        const next = front === a ? b : a;
        const url = Wallpapers.current ? `file://${Wallpapers.current}` : "";
        // Switching back within the fade: the image is still loaded, so no status change will fire.
        if (url && next.source.toString() === url && next.status === Image.Ready) front = next;
        else next.source = url;
    }

    // Drop the faded-out image once the cross-fade is over so only one
    // full-resolution wallpaper stays decoded in memory.
    property string staleSource: ""
    onFrontChanged: {
        staleSource = (front === a ? b : a).source.toString();
        release.restart();
    }
    Timer {
        id: release
        interval: Motion.duration.long * 2 + 100
        onTriggered: {
            const back = root.front === a ? b : a;
            if (back.source.toString() === root.staleSource) back.source = "";
        }
    }

    component Layer: Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        sourceSize: Qt.size(root.width * (root.screen?.devicePixelRatio ?? 1), root.height * (root.screen?.devicePixelRatio ?? 1))
        opacity: root.front === this ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Motion.duration.long * 2; easing.type: Easing.InOutQuad } }
        onStatusChanged: if (status === Image.Ready && root.front !== this) root.front = this
    }

    Layer { id: a }
    Layer { id: b }
}
