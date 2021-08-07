// Macro to fuse STK files together in a given order
// V2   2019-10-03    by C.Henry

// Define the paths
dir1 = getDirectory("Choose Main Directory");
dir2 = dir1 + "1_Images\\";
dir3 = dir2 + "Full-movies\\";
if (File.exists(dir3)!=1) {
	File.makeDirectory(dir3);
}

// Get the files from path
list2 = getFileList(dir2);
list3 = newArray(list2.length);

for (i=0; i<list2.length; i++) {
	if (endsWith(list2[i],"stk")>=1) {
// Extract the dish number to open the right ROIs
		FileName = list2[i];
		FileNameDishIndex = indexOf(FileName, "dish");
		if (FileNameDishIndex == -1) {
			FileNameDishIndex = indexOf(FileName, "Dish");
		}
		FileDishNumber = substring(FileName, FileNameDishIndex, FileNameDishIndex + 7);
		FileDishNumber2 = substring(FileName, FileNameDishIndex, FileNameDishIndex + 9);
// Test if the file as already been opened
		if (list3[i] != 0) {
			continue;
		}
// Test if the file is a 340 or 380 fura wavelength
		FuraNameIndex340 = indexOf(FileName, "340");
		FuraNameIndex380 = indexOf(FileName, "380");
		if (FuraNameIndex340 != -1) {
			for (j=i; j<list2.length; j++) {
				TestDish1 = indexOf(list2[j], FileDishNumber) != -1;
				TestDish2 = indexOf(list2[j], "340") != -1;
				if (TestDish1 == false || TestDish2 == false) {
					continue;
				}
				A = dir2+list2[j];
				open(A);
				list3[j] = list2[j];
			}
		}
		else if (FuraNameIndex380 != -1) {
			for (j=i; j<list2.length; j++) {
				TestDish1 = indexOf(list2[j], FileDishNumber) != -1;
				TestDish2 = indexOf(list2[j], "380") != -1;
				if (TestDish1 == false || TestDish2 == false) {
					continue;
				}
				A = dir2+list2[j];
				open(A);
				list3[j] = list2[j];
			}
		}
// Get number of open images and concatenate them all using sorting and indexing
		NumberOpenImages = getList("image.titles");
		NumberOpenImages  = Array.sort(NumberOpenImages);
		for (j=0; j<NumberOpenImages.length-1; j++) {
			run("Concatenate...",
				"  title=" + NumberOpenImages[j+1] + " open "
				+"image1=" + NumberOpenImages[j]
				+" image2=" + NumberOpenImages[j+1]);
		}
		NewName = replace(FileName,".stk","");
		NewName = replace(NewName,FileDishNumber2,FileDishNumber);
		saveAs ("Tiff", dir3 + NewName);
		close("*");
	}
}
