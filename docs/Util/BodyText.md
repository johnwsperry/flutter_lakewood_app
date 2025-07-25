﻿# BodyText Helper Documentation

*Mostly written by ChatGPT 4.1 (because I'm lazy af), reviewed and edited for accuracy*

This module provides a helper for streamlined creation of body text in Flutter apps.  
It allows you to globally control the scaling factor of text, making it easy to adjust text sizes throughout your app without modifying each `Text` widget individually.

---

## Functions

### 1. `bodyText`

Creates a styled `Text` widget for standard body text, with global scaling and customizable options.

**Signature:**
dart Text bodyText({ required String text, int fontSize = defaultBodyTextSize, Color color = Colors.black, String fontFamily = "robotoSlab", })


**Parameters:**

| Name       | Type      | Default                   | Description              |
|------------|-----------|---------------------------|--------------------------|
| `text`     | String    | _required_                | The text to display      |
| `fontSize` | int       | `defaultBodyTextSize` (16)| The base font size       |
| `color`    | Color     | `Colors.black`            | The color of the text    |
| `fontFamily`| String   | `"robotoSlab"`            | The font family to use   |

**Returns:**  
A Flutter `Text` widget with the specified styling and scaled font size.

---

### 2. `setTextSizeMulti`

Sets the global text size multiplier.

**Signature:**

dart void setTextSizeMulti(double size)
dart void setTextSizeMulti(double size)

#### Parameters

| Name | Type    | Description                                |
|------|---------|--------------------------------------------|
| size | double  | The new multiplier for scaling body text.  |

**Usage:**  
Call this function to change the scaling factor for all subsequent `bodyText` widgets.

---

### 3. `getTextSizeMulti`

Gets the current global text size multiplier.

**Signature:**

dart double getTextSizeMulti()

#### Returns

The current value of `textSizeMulti`.

---

## Usage Examples

dart import 'path/to/helper.dart';

// Show normal body text (default size) Widget example1 = bodyText(text: "This is body text.");

// Show body text with custom color and font size Widget example2 = bodyText( text: ;

// Change the global text size multiplier (e.g., user selects "Large Text" in settings) setTextSizeMulti(1.3);

// All subsequent bodyText widgets will now display larger text Widget example3 = bodyText(text: "Text will be 30% larger than base size.");

// Retrieve the current multiplier (e.g. for displaying in settings) double currentMulti = getTextSizeMulti();

---

## Notes

- The `textSizeMulti` variable is **global**. Changing it will affect all `bodyText` widgets created after the change.
- Existing widgets on screen **won’t update automatically** when `textSizeMulti` changes—you’ll need to trigger a rebuild (e.g., via `setState()` in a widget).
- You can override the font size, color, and font family for individual uses, but the multiplier will always apply unless you modify the code.
- If you omit `fontSize`, `color`, or `fontFamily`, the defaults (16, `Colors.black`, and `"robotoSlab"`) are used.

---

## Intended Use

Replace standard `Text()` widgets with `bodyText()` in your code when displaying body content.  
This enables easy global adjustments of body text size for accessibility or user preferences.

---

### Example Replacement

Instead of:

dart Text("Hello world", style: TextStyle(fontSize: 16))

Use:

dart bodyText(text: "Hello world")
