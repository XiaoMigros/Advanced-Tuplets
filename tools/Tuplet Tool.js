//=====================
// TUPLET TOOL FUNCTION
// v1.1
// changelog:
// code simplifications
// allow tuplet creation in last measure
//=====================

function createTuplet(tuplet1N, tuplet1D, tuplet2N, tuplet2D, includeNotes, numberType, bracketType) {
	var error = false;
	busy = true
	curScore.startCmd()
	console.log("Tuplet Tool: Running tuplet creation..")
	console.log(tuplet1N, tuplet1D, tuplet2N, tuplet2D)
	
	if (cur.element && (cur.element.type == Element.CHORD ||
		cur.element.type == Element.REST || cur.element.type == Element.NOTE)) {
		//retrieve values
		var startTick = cur.tick
		var endTick = startTick + (tuplet2N * tuplet2D * division * 4.0)
		
		curScore.appendMeasures(1)
		cur.nextMeasure()
		if (endTick <= cur.tick) {
			
			var tuplet1D2 = ((tuplet2N * tuplet2D) / tuplet1D)
			var tuplet2D2 = 1 / tuplet2D
			
			if (Math.round(tuplet1D2) == (tuplet1D2)) {
				if (includeNotes) {
					var tlength = (tuplet1N/tuplet1D2) * (endTick-startTick)
					var notes = logNotes(startTick, (startTick + tlength))
				}
				cur.rewindToTick(startTick)
				cur.addTuplet(fraction(tuplet1N, tuplet1D2), fraction(tuplet2N, tuplet2D2))
				customiseTuplet(numberType, bracketType)
				if (includeNotes) {
					addNotes(startTick, endTick, notes)
				}
				console.log("Tuplet Tool: Tuplet creation complete")
			} else {
				error = 3
				console.log("Error code " + error)
			}
		} else {
			error = 2
			console.log("Error code " + error)
		}
		removeElement(curScore.lastMeasure)
	} else {
		error = 1
		console.log("Error code " + error)
	}
	
	curScore.endCmd()
	busy = false
	return error;
}//createTuplet

function logNotes(startTick, endTick) {
	var notes = []
	cur.rewindToTick(startTick)
	while (cur.element && cur.tick < endTick) {
		var el = cur.element
		if (el && el.type == Element.CHORD || el.type == Element.REST || el.type == Element.NOTE) {
			var noterest = {duration: {}}
			noterest["duration"]["numerator"] = el.duration !== undefined ? el.duration.numerator : el.parent.duration.numerator;
			noterest["duration"]["denominator"] = el.duration !== undefined ? el.duration.denominator : el.parent.duration.denominator;
			switch (el.type) {
				case Element.NOTE: {
					if (el.parent.type == Element.CHORD) {
						noterest["type"] = "chord";
						var notetracker = [];
						for (var i in el.parent.notes) {
							notetracker.push(el.parent.notes[i].pitch)
						}
						noterest["pitches"] = notetracker
						break;
					} else {
						noterest["type"] = "note";
						noterest["pitch"] = el.pitch;
						break;
					}
				}
				case Element.REST: {
					console.log("====saving rest")
					noterest["type"] = "rest";
					break;
				}
				case Element.CHORD: {
					console.log("====saving chord:")
					noterest["type"] = "chord";
					var notetracker = [];
					for (var i in el.notes) {
						console.log("pitch: " + el.notes[i].pitch)
						notetracker.push(el.notes[i].pitch)
					}
					noterest["pitches"] = notetracker
					console.log("====")
					break;
				}
			}
			noterest["track"] = el.track;
			notes.push(noterest)
		}
		cur.next()
	}
	return notes;
}//logNotes

function addNotes(startTick, endTick, notes) {
	cur.rewindToTick(startTick)
	if (notes.length > 0) {
		for (var j in notes) {
			var noterest = notes[j];
			var temptick = cur.tick
			cur.track = noterest.track;
			cur.setDuration(noterest.duration.numerator, noterest.duration.denominator);
			switch (noterest.type) {
				case "rest": {
					console.log("adding rest at tick " + cur.tick)
					cur.addRest();
					break;
				}//rest
				case "note": {
					console.log("adding note at tick " + cur.tick + " with pitch " + noterest.pitch)
					cur.addNote(noterest.pitch)
					break;
				}//note
				case "chord": {
					console.log("adding chord at tick " + cur.tick + ":")
					for (var i in noterest.pitches) {
						console.log("adding pitch " + noterest.pitches[i])
						cur.addNote(noterest.pitches[i], (i != 0)) //addToChord has to be false for the first input note
					}
					console.log("created chord")
				}//chord
			}//switch
			cur.rewindToTick(temptick)
			cur.next()
		}//for var j
	}//if notes
}//addNotes

function customiseTuplet(numbType, bracType) {
	cur.element.tuplet.bracketType = bracType
	cur.element.tuplet.numberType = numbType
}//customiseTuplet
