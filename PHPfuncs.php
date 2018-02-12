// Takes array[x] and searches it for key
    function in_array_recursive($value, array $array) {
        $newArrays = []; // empty array for recursion
        if (is_array($array)) { // if array is an array
            foreach ($array as $element) { // iterate through each element
                if (is_array($element)) { // if the element is an array
                    if (in_array($value, $element)) { // check for key
                        return true;
                    } elseif (!empty($element)) { // else if not an empty array or null variable
                        $newArrays[] = $element;
                    } else {
                        unset($element); // cleanup unused arrays
                    }
                } else { // else if not an array or an empty array
                    if ($value == $element) {
                        return true;
                    } else {
                        unset($element); // cleanup unused vars
                    }
                }
            }
        }
        $foundBool = false;
        // If newArr is not empty, walk through and recursively search
        foreach ($newArrays as $newArray) {
            if (is_array($newArray)) { // if array
                $foundBool = in_array_recursive($value, $newArray); // recursively search
            } elseif ($newArray === $value) { // check if key
                $foundBool = true;
            } else { // otherwise not found

                $foundBool = false;
            }
        }
        // else return false
        return $foundBool;
    }
