import QtQuick 2.0

ListModel {
	ListElement {text: qsTr("Longa(s)");			fact: 4}
	ListElement {text: qsTr("Double Whole Note(s)");fact: 2}
	ListElement {text: qsTr("Whole Note(s)");		fact: 1}
	ListElement {text: qsTr("Half(s)");				fact: 0.5}
	ListElement {text: qsTr("Quarter(s)");			fact: 0.25}
	ListElement {text: qsTr("Eighth(s)");			fact: 0.125}
	ListElement {text: qsTr("16th(s)");				fact: 0.0625}
	ListElement {text: qsTr("32nd(s)");				fact: 0.03125}
	ListElement {text: qsTr("64th(s)");				fact: 0.015625}
}