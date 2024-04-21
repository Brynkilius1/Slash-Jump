extends Node2D


func PlayRandomSound(collection_name : String):
	var returned_collection = CheckChildrenForCollections(collection_name)
	if returned_collection != null:
		returned_collection.PlayRandomSound()
	else:
		print(self, " didnt find an audio collection with name: ", collection_name, "!")




func StopCollectionSound(collection_name : String):
	var returned_collection = CheckChildrenForCollections(collection_name)
	if returned_collection != null:
		returned_collection.StopCollectionsSound()



func CheckChildrenForCollections(collection_being_searched_for, node_to_be_checked = self): #Searches for an audio collection with the name you enter as firt parameter, returns -1 if it finds nothing
	
	for i in node_to_be_checked.get_children(): #Checking every childof the audio master
		
		if i.is_in_group("AudioCollection"): #Checks if node is in audio collection group
			if i.name == "AudioCollection" + collection_being_searched_for: #If name matches return i, else try again
				
				return i
			else:
				var returned_var = CheckChildrenForCollections(collection_being_searched_for, i) #return chain
				if returned_var != null:
					return returned_var
	return null


func StopAllSound():
	print("ill implament this later")
	pass
