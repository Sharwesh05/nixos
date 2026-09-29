import QtQuick
import qs.config

// Material Symbols Rounded glyph. `fill` animates between outlined and filled.
//
// The glyph sits in a fixed size x size box: animating the font's FILL axis
// re-shapes the glyph every frame and its measured width wobbles slightly,
// which made anything laid out next to an icon (tab strips, rows of chips)
// jitter during the animation. Layouts only ever see the fixed box.
Item {
    id: root

    property real size: 20
    property real fill: 0
    property alias text: glyph.text
    property color color: Theme.surfaceFg
    property alias font: glyph.font
    property alias horizontalAlignment: glyph.horizontalAlignment
    property alias verticalAlignment: glyph.verticalAlignment

    implicitWidth: size
    implicitHeight: size

    Text {
        id: glyph
        anchors.fill: parent
        font.family: Tokens.font.icons
        font.pixelSize: root.size
        font.variableAxes: ({ "FILL": root.fill, "opsz": Math.min(48, Math.max(20, root.size)), "wght": 450 })
        color: root.color
        Behavior on color { ColorAnim {} }
        renderType: Text.NativeRendering
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Behavior on fill { Anim {} }
}
