//=====================
// TUPLET TOOL UI
// v1.0
// changelog:
//=====================

import QtQuick 2.0;
import QtQuick.Dialogs 1.2;
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtQuick.Controls 1.5
import Qt.labs.settings 1.0;
import MuseScore 3.0;
import "tools/Tuplet Tool.js" as TT
import "lists"

MuseScore {
	menuPath: "Plugins." + qsTr("Add Tuplet")
	description: qsTr("A more precise & easily customisable tuplet input option.")
	version: "1.0"
	property var error: false;
	property var cur;
	property bool busy;
	property bool add: false;
	
	property var tupletA: tuplet1N.value
	property var tupletB: (tuplet1D.model.get(tuplet1D.currentIndex).fact *
				(tuplet1T.model.get(tuplet1T.currentIndex).n / tuplet1T.model.get(tuplet1T.currentIndex).d))
	property var tupletC: (tuplet2N.value * tuplet2T.model.get(tuplet2T.currentIndex).n)
	property var tupletD: (tuplet2D.model.get(tuplet2D.currentIndex).fact / tuplet2T.model.get(tuplet2T.currentIndex).d)
	property var tupletX: tupletC * tupletD / tupletB
	property bool invalid: Math.round(tupletX) != tupletX
	property var bracketType: bracketauto.checked ? 0 : (bracketbracket.checked ? 1 : 2)
	property var numberType: numbernumber.checked ? 0 : (numberratio.checked ? 1 : 2)
	
	Component.onCompleted : {
        if (mscoreMajorVersion >= 4) {
            title = "Advanced Tuplets"
			categoryCode = "notes-rests"
        }
    }//Component
	
	onRun: {
		cur = curScore.newCursor()
		cur.inputStateMode = Cursor.INPUT_STATE_SYNC_WITH_SCORE
		tupletWindow.visible = true
	}
	
	onScoreStateChanged: {
		if (! busy && add && state.selectionChanged) {
			actuallyRunPlugin()
		}
	}
	
	function runPlugin() {
		if (! busy && add && cur.element && (cur.element.type == Element.CHORD ||
			cur.element.type == Element.REST || cur.element.type == Element.NOTE)) {
			actuallyRunPlugin()
		}
	}
	
	function actuallyRunPlugin() {
		error = TT.createTuplet(
			tupletA, tupletB, tupletC, tupletD,
			addNotes.checked, bracketType, numberType
		)
		if (error != false) {
			showError(error)
		}
		add = false
		smartQuit()
	}
	
	ApplicationWindow {
		id: tupletWindow
		title: qsTr("Add Tuplet")
		visible: false
		height: tupletValues.height + buttonsRow.height + 30
		width: Math.max(tupletValues.width, buttonsRow.width) + 20
		flags: Qt.Dialog
		maximumHeight: height
		maximumWidth: width
		minimumHeight: height
		minimumWidth: width
		
		ColumnLayout {
			id: tupletValues
			spacing: 10
			y: 10
			anchors.horizontalCenter: parent.horizontalCenter
			
			Label {text: qsTr("Create a Tuplet Consisting of"); anchors.horizontalCenter: parent.horizontalCenter}
			
			RowLayout {
				id: top
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.margins: 5;
				anchors.leftMargin: 10;
				anchors.rightMargin: 10;
				
				SpinBox {id: tuplet1N; minimumValue: 1; value: 3;
				implicitWidth: 60; implicitHeight: 30;}//spinbox
				
				ComboBox {id: tuplet1T; implicitWidth: 120; height: 30;
					currentIndex: 0; model: TupletDotListModel {}
				}//combobox
				
				ComboBox {id: tuplet1D; implicitWidth: 120; height: 30;
					currentIndex: 4; model: TupletNoteListModel {}
				}//combobox
			}
			
			Label {text: qsTr("In the Space of"); anchors.horizontalCenter: parent.horizontalCenter}
			
			RowLayout {
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.margins: 5;
				anchors.leftMargin: 10;
				anchors.rightMargin: 10;
				
				SpinBox {id: tuplet2N; minimumValue: 1; value: 1;
				implicitWidth: 60; implicitHeight: 30;}//spinbox
				
				ComboBox {id: tuplet2T; implicitWidth: 120; height: 30;
					currentIndex: 0; model: TupletDotListModel {}
				}//combobox
				
				ComboBox {id: tuplet2D; implicitWidth: 120; height: 30;
					currentIndex: 3; model: TupletNoteListModel {}
				}//combobox
			}//rowlayout
			
			GroupBox {
				title: qsTr("Format")
				anchors.margins: 10
				implicitWidth: parent.width
				enabled: ! invalid
				opacity: enabled ? 1.0 : 0.5
					
				GroupBox {
					id: tupletNumber
					title: qsTr("Number")
					implicitWidth: (parent.width - 10) / 2
					anchors.left: parent.left
					
					ColumnLayout {
						anchors.margins: 10;
						spacing: 10
						
						ExclusiveGroup {id: numberGroup}
						
						RadioButton {id: numbernumber; checked: true;
							exclusiveGroup: numberGroup
							text: qsTr("Number") + (invalid ? "" : (" (" + tupletA + ")"))
						}
						RadioButton {id: numberratio; checked: false;
							exclusiveGroup: numberGroup
							text: qsTr("Ratio") + (invalid ? "" : " (" + tupletA + ":" + tupletX + ")")
						}
						RadioButton {id: numbernone; checked: false;
							exclusiveGroup: numberGroup
							text: qsTr("None")
						}
					}//columnlayout
				}//groupbox
					
					GroupBox {
						id: tupletBracket
						title: qsTr("Bracket")
						implicitWidth: (parent.width - 10) / 2
						anchors.right: parent.right
						
						ColumnLayout {
							anchors.margins: 10;
							spacing: 10
							
							ExclusiveGroup {id: bracketGroup}
							
							RadioButton {id: bracketauto; checked: true
								exclusiveGroup: bracketGroup
								text: qsTr("Auto")
							}
							RadioButton {id: bracketbracket;checked: false
								exclusiveGroup: bracketGroup
								text: qsTr("Bracket")
							}
							RadioButton {id: bracketnone; checked: false
								exclusiveGroup: bracketGroup
								text: qsTr("None")
							}
						}//columnlayout
					}//groupbox
			}//GroupBox
			
			CheckBox {id: addNotes; text: qsTr("Copy Notes into Tuplet"); checked: true;
				anchors.horizontalCenter: parent.horizontalCenter
				enabled: ! invalid
				opacity: enabled ? 1.0 : 0.5
			}
			
			Label {
				anchors.horizontalCenter: parent.horizontalCenter
				text: qsTr("Hint") + ": " + 
					(invalid ? qsTr("The currently entered tuplet is probably invalid.") : ("Select a note/rest in the score to add the tuplet."))
				font.italic: true
			}
		}//Column
		
		RowLayout {
			id: buttonsRow
			anchors.margins: 10;
			x: parent.width - (width+10);
			y: parent.height - (height+10);
			  
			Button {
				id: tupletHelpButton
				text: qsTr("Help")
				onClicked: {
					Qt.openUrlExternally("https://github.com/xiaomigros/advanced-tuplets#readme")
				}
			}//leftbutton
					
			Button {
				id: tupletCancelButton
				text: qsTr("Cancel")
				onClicked: {
					smartQuit()
				}
			}//leftbutton
					
			Button {
				id: rightButton
				text: qsTr("OK")
				enabled: ! invalid
				opacity: enabled ? 1.0 : 0.5
				onClicked: {
					add = true
					tupletWindow.visible = false
					runPlugin()
				}
			}//rightbutton
		}//rowlayout
		
		Settings {
			id:								settings;
			category:						"AdvancedTuplet"
			property alias height:			tupletWindow.height;
			property alias width:			tupletWindow.width;
			property alias tuplet1N:		tuplet1N.value;
			property alias tuplet1D:		tuplet1D.currentIndex;
			property alias tuplet1T:		tuplet1T.currentIndex;
			property alias tuplet2N:		tuplet2N.value;
			property alias tuplet2T:		tuplet2T.currentIndex;
			property alias tuplet2D:		tuplet2D.currentIndex;
			property alias addNotes:		addNotes.checked;
		}
	}//dialog
	
	MessageDialog {
		id: errorDialog
		title: qsTr("Tuplet Error")
		modality: Qt.ApplicationModal
		icon: StandardIcon.Warning
		text: error
		onAccepted: {smartQuit()}
	}
	
	function showError(errcode) {
		switch (errcode) {
			case 1: {
				error = qsTr("Error: No note or rest selected")
				break;
			}
			case 2: {
				error = qsTr("Error: Tuplet extends across measures")
				break;
			}
			case 3: {
				error = qsTr("Error: Cannot create tuplet with entered ratio and duration")
				break;
			}
			default: {
				error = qsTr("Unknown Error")
				break;
			}
		}//switch
		errorDialog.open()
	}
	
	function smartQuit() {
		tupletWindow.visible = false
		if (mscoreMajorVersion < 4) {Qt.quit()}
		else {quit()}
	}//smartQuit
	
	Timer {
        id: updateTimer
        interval: 33 // ms
		running: mscoreMajorVersion >= 4
        repeat: true
        onTriggered: {
			runPlugin()
		}
    }//Timer
}//MuseScore