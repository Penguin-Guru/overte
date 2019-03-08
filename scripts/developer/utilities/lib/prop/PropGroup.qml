//
//  PropGroup.qml
//
//  Created by Sam Gateau on 3/2/2019
//  Copyright 2019 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or https://www.apache.org/licenses/LICENSE-2.0.html
//

import QtQuick 2.7

Item {
    Global { id: global }
    id: root
    
    // Prop Group is designed to author an array of ProItems, they are defined with an array of the tuplets describing each individual item:
    // [ ..., PropItemInfo, ...]
    // PropItemInfo {
    //    type: "PropXXXX", object: JSobject, property: "propName"      
    // }
    //
    property var propItems: []


    property var label: "group"

    property var isUnfold: false

    Item {
        id: header
        height: global.slimHeight
        anchors.left: parent.left           
        anchors.right: parent.right
    
        PropLabel {
            id: labelControl
            anchors.left: header.left
            width: 0.8 * header.width
            anchors.verticalCenter: header.verticalCenter
            text: root.label
            horizontalAlignment: Text.AlignHCenter
        }

        Rectangle {
            id: headerRect
            color: global.color
            border.color: global.colorBorderLight
            border.width: global.valueBorderWidth
            radius: global.valueBorderRadius
           
            anchors.left: labelControl.right
            anchors.right: header.right
            anchors.verticalCenter: header.verticalCenter
            height: parent.height

            MouseArea{
                id: mousearea
                anchors.fill: parent
                onDoubleClicked: {
                    root.isUnfold = !root.isUnfold
                }
            }
        }
    }
    
    Column {
        id: column
        visible: root.isUnfold
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right   
        clip: true

        // Where the propItems are added
    }
    height: header.height + isUnfold * column.height

    function updatePropItems() {
         for (var i = 0; i < root.propItems.length; i++) {
            var proItem = root.propItems[i];
            // valid object
            if (proItem['object'] !== undefined && proItem['object'] !== null ) {
                // valid property
                if (proItem['property'] !== undefined && proItem.object[proItem.property] !== undefined) {
                    // check type
                    if (proItem['type'] === undefined) {
                        proItem['type'] = typeof(proItem.object[proItem.property])
                    }
                    switch(proItem.type) {
                        case 'boolean':
                        case 'PropBool': {
                            var component = Qt.createComponent("PropBool.qml");
                            component.createObject(column, {
                                "label": proItem.property,
                                "object": proItem.object,
                                "property": proItem.property
                            })
                        } break;
                        case 'number':
                        case 'PropScalar': {
                            var component = Qt.createComponent("PropScalar.qml");
                            component.createObject(column, {
                                "label": proItem.property,
                                "object": proItem.object,
                                "property": proItem.property,
                                "min": (proItem["min"] !== undefined ? proItem.min : 0.0),                   
                                "max": (proItem["max"] !== undefined ? proItem.max : 1.0),                                       
                                "integer": (proItem["integral"] !== undefined ? proItem.integral : false),
                            })
                        } break;
                        case 'PropEnum': {
                            var component = Qt.createComponent("PropEnum.qml");
                            component.createObject(column, {
                                "label": proItem.property,
                                "object": proItem.object,
                                "property": proItem.property,
                                "enums": (proItem["enums"] !== undefined ? proItem.enums : ["Undefined Enums !!!"]), 
                            })
                        } break;
                        case 'object': {
                            var component = Qt.createComponent("PropItem.qml");
                            component.createObject(column, {
                                "label": proItem.property,
                                "object": proItem.object,
                                "property": proItem.property,
                             })
                        } break;
                    }
                } else {
                    console.log('Invalid property: ' + JSON.stringify(proItem));
                }
            } else {
                console.log('Invalid object: ' + JSON.stringify(proItem));
            }
        }
    }
    Component.onCompleted: {
        updatePropItems();
    }
}
