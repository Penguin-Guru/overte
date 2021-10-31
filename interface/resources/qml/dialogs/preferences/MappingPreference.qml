//
//  MappingPreference.qml
//
//  Based heavily on a file created by Bradley Austin Davis on 18 Jan 2016
//

import QtQuick 2.5

import "../../dialogs"
import controlsUit 1.0

Preference {
    id: root
    height: mapping.height + hifi.dimensions.controlInterlineHeight

    Component.onCompleted: {
        mapping.shortcut.sequence = preference.value;
        //mapping.shortcut.sequence = preference.value.portableText;
        //mapping.shortcut.sequence = "A";

        //mapping.text = mapping.shortcut.nativeText;
        mapping.text = preference.value;
        //mapping.text = preference.value.nativeText;
    }

    function save() {
        preference.value = mapping.shortcut.portableText;
        preference.save();
    }

    Mapping {
        id: mapping
        //label: preference.label // Not sure why this doesn't work.
        label: root.label // This must be assigned automatically?
        text: preference.value
        //text: preference.value.nativeText // This does not work.

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }
}
