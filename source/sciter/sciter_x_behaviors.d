// Copyright 2015 Ramon F. Mendes
// 
// This file is part of sciter-dport.
// 
// sciter-dport is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
// sciter-dport is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
// You should have received a copy of the GNU General Public License along with Foobar. If not, see http://www.gnu.org/licenses/.

module sciter.sciter_x_behaviors;

/*
From: sciter-x-behavior.h
only the top part 
*/

import sciter.sciter_x_types;
import sciter.sciter_x_dom;
import sciter.sciter_x_value;
import sciter.tiscript;


extern(Windows)
{
	enum EVENT_GROUPS : UINT
	{
		HANDLE_INITIALIZATION = 0x0000, /** attached/detached */
		HANDLE_MOUSE = 0x0001,          /** mouse events */
		HANDLE_KEY = 0x0002,            /** key events */
		HANDLE_FOCUS = 0x0004,          /** focus events, if this flag is set it also means that element it attached to is focusable */
		HANDLE_SCROLL = 0x0008,         /** scroll events */
		HANDLE_TIMER = 0x0010,          /** timer event */
		HANDLE_SIZE = 0x0020,           /** size changed event */
		//HANDLE_DRAW = 0x0040,           /** drawing request (event) */
		HANDLE_DATA_ARRIVED = 0x080,    /** requested data () has been delivered */
		HANDLE_BEHAVIOR_EVENT        = 0x0100, /** logical, synthetic events:
												BUTTON_CLICK, HYPERLINK_CLICK, etc.,
												a.k.a. notifications from intrinsic behaviors */
		HANDLE_METHOD_CALL           = 0x0200, /** behavior specific methods */
		HANDLE_SCRIPTING_METHOD_CALL = 0x0400, /** behavior specific methods */
		HANDLE_TISCRIPT_METHOD_CALL  = 0x0800, /** behavior specific methods using direct tiscript::value's */

		HANDLE_EXCHANGE              = 0x1000, /** system drag-n-drop */
		HANDLE_GESTURE               = 0x2000, /** touch input events */

		HANDLE_ALL                   = 0xFFFF, /* all of them */

		SUBSCRIPTIONS_REQUEST        = 0xFFFFFFFF, /** special value for getting subscription flags */
	}
	
	alias BOOL /*__stdcall*/ function(LPVOID tag, HELEMENT he, UINT evtg, LPVOID prms) LPElementEventProc;
	alias BOOL /*__stdcall*/ function(LPCSTR, HELEMENT, LPElementEventProc*, LPVOID*) SciterBehaviorFactory;
	
	enum PHASE_MASK : UINT
	{
		BUBBLING = 0,
		SINKING  = 0x8000,
		HANDLED  = 0x10000
	}

	enum MOUSE_BUTTONS : UINT
	{
		MAIN_MOUSE_BUTTON = 1,
		PROP_MOUSE_BUTTON = 2,
		MIDDLE_MOUSE_BUTTON = 4,
	}

	enum KEYBOARD_STATES : UINT
	{
		CONTROL_KEY_PRESSED = 0x1,
		SHIFT_KEY_PRESSED = 0x2,
		ALT_KEY_PRESSED = 0x4
	}
	
	enum INITIALIZATION_EVENTS : UINT
	{
		BEHAVIOR_DETACH = 0,
		BEHAVIOR_ATTACH = 1
	}

	struct INITIALIZATION_PARAMS
	{
		/*UINT*/INITIALIZATION_EVENTS cmd;
	}

	enum DRAGGING_TYPE : UINT
	{
		NO_DRAGGING,
		DRAGGING_MOVE,
		DRAGGING_COPY,
	}
		
	enum MOUSE_EVENTS : UINT
	{
		MOUSE_ENTER = 0,
		MOUSE_LEAVE,
		MOUSE_MOVE,
		MOUSE_UP,
		MOUSE_DOWN,
		MOUSE_DCLICK,
		MOUSE_WHEEL,
		MOUSE_TICK,
		MOUSE_IDLE,
		DROP        = 9,
		DRAG_ENTER  = 0xA,
		DRAG_LEAVE  = 0xB,  
		DRAG_REQUEST = 0xC,
		MOUSE_CLICK = 0xFF,
		DRAGGING = 0x100,
	}

	struct MOUSE_PARAMS
	{
		UINT      cmd;
		HELEMENT  target;
		POINT     pos;
		POINT     pos_view; 
		UINT      button_state;
		UINT      alt_state;
		UINT      cursor_type;
		BOOL      is_on_icon;
		HELEMENT  dragging;
		UINT      dragging_mode;
	}

	enum CURSOR_TYPE : UINT
	{
		CURSOR_ARROW,
		CURSOR_IBEAM,
		CURSOR_WAIT,
		CURSOR_CROSS,
		CURSOR_UPARROW,
		CURSOR_SIZENWSE,
		CURSOR_SIZENESW,
		CURSOR_SIZEWE,
		CURSOR_SIZENS,
		CURSOR_SIZEALL,
		CURSOR_NO,
		CURSOR_APPSTARTING,
		CURSOR_HELP,
		CURSOR_HAND,
		CURSOR_DRAG_MOVE,
		CURSOR_DRAG_COPY,
	}
	
	enum KEY_EVENTS : UINT
	{
		KEY_DOWN = 0,
		KEY_UP,
		KEY_CHAR
	}

	struct KEY_PARAMS
	{
		UINT      cmd;
		HELEMENT  target; 
		UINT      key_code;
		UINT      alt_state;
	}
	
	enum FOCUS_EVENTS : UINT
	{
		FOCUS_LOST = 0,
		FOCUS_GOT = 1,
	}

	struct FOCUS_PARAMS
	{
		UINT      cmd;
		HELEMENT  target;
		BOOL      by_mouse_click;
		BOOL      cancel;
	}
	
	enum SCROLL_EVENTS : UINT
	{
		SCROLL_HOME = 0,
		SCROLL_END,
		SCROLL_STEP_PLUS,
		SCROLL_STEP_MINUS,
		SCROLL_PAGE_PLUS,
		SCROLL_PAGE_MINUS,
		SCROLL_POS,
		SCROLL_SLIDER_RELEASED,
		SCROLL_CORNER_PRESSED,
		SCROLL_CORNER_RELEASED,
	}

	struct SCROLL_PARAMS
	{
		UINT      cmd;
		HELEMENT  target;
		INT       pos;
		BOOL      vertical;
	}

	enum GESTURE_CMD : UINT
	{
		GESTURE_REQUEST = 0,
		GESTURE_ZOOM,
		GESTURE_PAN,
		GESTURE_ROTATE,
		GESTURE_TAP1,
		GESTURE_TAP2,
	}
	
	enum GESTURE_STATE : UINT
	{
		GESTURE_STATE_BEGIN   = 1,
		GESTURE_STATE_INERTIA = 2,
		GESTURE_STATE_END     = 4,
	}

	enum GESTURE_TYPE_FLAGS : UINT
	{
		GESTURE_FLAG_ZOOM               = 0x0001,
		GESTURE_FLAG_ROTATE             = 0x0002,
		GESTURE_FLAG_PAN_VERTICAL       = 0x0004,
		GESTURE_FLAG_PAN_HORIZONTAL     = 0x0008,
		GESTURE_FLAG_TAP1               = 0x0010,
		GESTURE_FLAG_TAP2               = 0x0020,
		GESTURE_FLAG_PAN_WITH_GUTTER    = 0x4000,
		GESTURE_FLAG_PAN_WITH_INERTIA   = 0x8000,
		GESTURE_FLAGS_ALL               = 0xFFFF,
	}

	struct GESTURE_PARAMS
	{
		UINT      cmd;
		HELEMENT  target;
		POINT     pos;
		POINT     pos_view;
		UINT      flags;
		UINT      delta_time;
		SIZE      delta_xy;
		double    delta_v;
	}

	enum DRAW_EVENTS : UINT
	{
		DRAW_BACKGROUND = 0,
		DRAW_CONTENT = 1,
		DRAW_FOREGROUND = 2,
	}

	struct SCITER_GRAPHICS;

	struct DRAW_PARAMS
	{
		UINT				cmd;
		SCITER_GRAPHICS*	gfx;
		RECT				area;
		UINT				reserved;
	}

	enum CONTENT_CHANGE_BITS : UINT	// for CONTENT_CHANGED reason
	{
		CONTENT_ADDED = 0x01,
		CONTENT_REMOVED = 0x02,
	}

	enum BEHAVIOR_EVENTS : UINT
	{
		BUTTON_CLICK = 0,              // click on button
		BUTTON_PRESS = 1,              // mouse down or key down in button
		BUTTON_STATE_CHANGED = 2,      // checkbox/radio/slider changed its state/value
		EDIT_VALUE_CHANGING = 3,       // before text change
		EDIT_VALUE_CHANGED = 4,        // after text change
		SELECT_SELECTION_CHANGED = 5,  // selection in <select> changed
		SELECT_STATE_CHANGED = 6,      // node in select expanded/collapsed, heTarget is the node

		POPUP_REQUEST   = 7,           // request to show popup just received,
		//     here DOM of popup element can be modifed.
		POPUP_READY     = 8,           // popup element has been measured and ready to be shown on screen,
		//     here you can use functions like ScrollToView.
		POPUP_DISMISSED = 9,           // popup element is closed,
		//     here DOM of popup element can be modifed again - e.g. some items can be removed
		//     to free memory.

		MENU_ITEM_ACTIVE = 0xA,        // menu item activated by mouse hover or by keyboard,
		MENU_ITEM_CLICK = 0xB,         // menu item click,
		//   BEHAVIOR_EVENT_PARAMS structure layout
		//   BEHAVIOR_EVENT_PARAMS.cmd - MENU_ITEM_CLICK/MENU_ITEM_ACTIVE
		//   BEHAVIOR_EVENT_PARAMS.heTarget - owner(anchor) of the menu
		//   BEHAVIOR_EVENT_PARAMS.he - the menu item, presumably <li> element
		//   BEHAVIOR_EVENT_PARAMS.reason - BY_MOUSE_CLICK | BY_KEY_CLICK


		CONTEXT_MENU_REQUEST = 0x10,   // "right-click", BEHAVIOR_EVENT_PARAMS::he is current popup menu HELEMENT being processed or NULL.
		// application can provide its own HELEMENT here (if it is NULL) or modify current menu element.

		VISIUAL_STATUS_CHANGED = 0x11, // broadcast notification, sent to all elements of some container being shown or hidden
		DISABLED_STATUS_CHANGED = 0x12,// broadcast notification, sent to all elements of some container that got new value of :disabled state

		POPUP_DISMISSING = 0x13,       // popup is about to be closed

		CONTENT_CHANGED = 0x15,        // content has been changed, is posted to the element that gets content changed,  reason is combination of CONTENT_CHANGE_BITS.
		// target == NULL means the window got new document and this event is dispatched only to the window.

		// "grey" event codes  - notfications from behaviors from this SDK
		HYPERLINK_CLICK = 0x80,        // hyperlink click

		//TABLE_HEADER_CLICK,            // click on some cell in table header,
		//                               //     target = the cell,
		//                               //     reason = index of the cell (column number, 0..n)
		//TABLE_ROW_CLICK,               // click on data row in the table, target is the row
		//                               //     target = the row,
		//                               //     reason = index of the row (fixed_rows..n)
		//TABLE_ROW_DBL_CLICK,           // mouse dbl click on data row in the table, target is the row
		//                               //     target = the row,
		//                               //     reason = index of the row (fixed_rows..n)

		ELEMENT_COLLAPSED = 0x90,      // element was collapsed, so far only behavior:tabs is sending these two to the panels
		ELEMENT_EXPANDED,              // element was expanded,

		ACTIVATE_CHILD,                // activate (select) child,
		// used for example by accesskeys behaviors to send activation request, e.g. tab on behavior:tabs.

		//DO_SWITCH_TAB = ACTIVATE_CHILD,// command to switch tab programmatically, handled by behavior:tabs
		//                               // use it as HTMLayoutPostEvent(tabsElementOrItsChild, DO_SWITCH_TAB, tabElementToShow, 0);

		INIT_DATA_VIEW,                // request to virtual grid to initialize its view

		ROWS_DATA_REQUEST,             // request from virtual grid to data source behavior to fill data in the table
		// parameters passed throug DATA_ROWS_PARAMS structure.

		UI_STATE_CHANGED,              // ui state changed, observers shall update their visual states.
		// is sent for example by behavior:richtext when caret position/selection has changed.

		FORM_SUBMIT,                   // behavior:form detected submission event. BEHAVIOR_EVENT_PARAMS::data field contains data to be posted.
		// BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about 
		// to be submitted. You can modify the data or discard submission by returning true from the handler.
		FORM_RESET,                    // behavior:form detected reset event (from button type=reset). BEHAVIOR_EVENT_PARAMS::data field contains data to be reset.
		// BEHAVIOR_EVENT_PARAMS::data is of type T_MAP in this case key/value pairs of data that is about 
		// to be rest. You can modify the data or discard reset by returning true from the handler.

		DOCUMENT_COMPLETE,             // document in behavior:frame or root document is complete.

		HISTORY_PUSH,                  // requests to behavior:history (commands)
		HISTORY_DROP,                     
		HISTORY_PRIOR,
		HISTORY_NEXT,
		HISTORY_STATE_CHANGED,         // behavior:history notification - history stack has changed

		CLOSE_POPUP,                   // close popup request,
		REQUEST_TOOLTIP,               // request tooltip, evt.source <- is the tooltip element.

		ANIMATION         = 0xA0,      // animation started (reason=1) or ended(reason=0) on the element.
		DOCUMENT_CREATED  = 0xC0,      // document created, script namespace initialized. target -> the document

		VIDEO_INITIALIZED = 0xD1,      // <video> "ready" notification   
		VIDEO_STARTED     = 0xD2,      // <video> playback started notification   
		VIDEO_STOPPED     = 0xD3,      // <video> playback stoped/paused notification   
		VIDEO_BIND_RQ     = 0xD4,      // <video> request for frame source binding, 
										//   If you want to provide your own video frames source for the given target <video> element do the following:
										//   1. Handle and consume this VIDEO_BIND_RQ request 
										//   2. You will receive second VIDEO_BIND_RQ request/event for the same <video> element
										//      but this time with the 'reason' field set to an instance of sciter::video_destination interface.
										//   3. add_ref() it and store it for example in worker thread producing video frames.
										//   4. call sciter::video_destination::start_streaming(...) providing needed parameters
										//      call sciter::video_destination::render_frame(...) as soon as they are available
										//      call sciter::video_destination::stop_streaming() to stop the rendering (a.k.a. end of movie reached)



		FIRST_APPLICATION_EVENT_CODE = 0x100
		// all custom event codes shall be greater
		// than this number. All codes below this will be used
		// solely by application - HTMLayout will not intrepret it
		// and will do just dispatching.
		// To send event notifications with  these codes use
		// HTMLayoutSend/PostEvent API.
	}

	enum EVENT_REASON : UINT
	{
		BY_MOUSE_CLICK,
		BY_KEY_CLICK,
		SYNTHESIZED,
	}

	enum EDIT_CHANGED_REASON : UINT
	{
		BY_INS_CHAR,
		BY_INS_CHARS,
		BY_DEL_CHAR,
		BY_DEL_CHARS,
	}

	struct BEHAVIOR_EVENT_PARAMS
	{
		UINT     cmd;
		HELEMENT heTarget;
		HELEMENT he;
		UINT_PTR reason;
		SCITER_VALUE data;
	}

	struct TIMER_PARAMS
	{
		UINT_PTR timerId;
	}
	
	enum BEHAVIOR_METHOD_IDENTIFIERS : UINT
	{
		DO_CLICK = 0,
		GET_TEXT_VALUE = 1,
		SET_TEXT_VALUE,
		TEXT_EDIT_GET_SELECTION,
		TEXT_EDIT_SET_SELECTION,
		TEXT_EDIT_REPLACE_SELECTION,
		SCROLL_BAR_GET_VALUE,
		SCROLL_BAR_SET_VALUE,
		TEXT_EDIT_GET_CARET_POSITION, 
		TEXT_EDIT_GET_SELECTION_TEXT,
		TEXT_EDIT_GET_SELECTION_HTML,
		TEXT_EDIT_CHAR_POS_AT_XY,
		IS_EMPTY      = 0xFC,
		GET_VALUE     = 0xFD,
		SET_VALUE     = 0xFE,
		FIRST_APPLICATION_METHOD_ID = 0x100
	}
	
	alias BEHAVIOR_METHOD_IDENTIFIERS eBehaviorMethodIdentifiers;

	struct METHOD_PARAMS
	{
		UINT methodID; // see: enum BEHAVIOR_METHOD_IDENTIFIERS
	}

	struct SCRIPTING_METHOD_PARAMS
	{
		LPCSTR        name;
		VALUE*		  argv;
		UINT          argc;
		VALUE		  result;	// plz note, Sciter will internally call ValueClear to this VALUE,
								// that is, it own this data, so always assign a reference-copy of your VALUE to this variable
								// you will know that if you get an "Access Violation" error
								// see json_value.copy() - midi
	}

	struct TISCRIPT_METHOD_PARAMS
	{
		tiscript_VM*   vm;
		tiscript_value tag;
		tiscript_value result;
	}
	
	struct DATA_ARRIVED_PARAMS
	{
		HELEMENT  initiator;
		LPCBYTE   data;
		UINT      dataSize;
		UINT      dataType;
		UINT      status;
		LPCWSTR   uri;
	}
}