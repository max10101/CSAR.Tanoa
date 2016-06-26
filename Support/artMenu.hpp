class artMenu
{
	idd = 100001;
	movingEnable = 1;
	controlsBackground[] = {background};
	objects[] = {};
	onLoad="uiNamespace setVariable ['artMenu', _this select 0]";
	controls[] = {bgEdge,bottom,top,lineTop,lineBottom,btnRequest,btnDummy,btnExit,checkEdge,checkbg,Checkbox,RoundsCheckEdge,RoundsCheckbg,RoundsCheckbox,AreaCheckEdge,AreaCheckbg,AreaCheckbox,mapbg,map,remainingTitle1,remainingTitle2,remainingText,roundsTitle,spreadTitle,help};


	class background : JWC_BG
	{
		x = 0.0;
		y = 0.0;
		w = 0.525;
		h = 0.760;
		idc = 100199;
		colorBackground[] = {0, 0, 0, 1};
	};


	class bgEdge : JWC_Text
	{
  	        x = 0.001;
  	        y = 0.001;
  	        w = 0.522;
                h = 0.757;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {0.65, 0.65, 0.65, 1};
                moving = 0;
		text = "";
	};


	class btnExit: JWC_Button
        {
		idc = 100111;
		text = "Exit Menu";
		action = "closeDialog 0";
		y = 0.7;
                x = 0.400;
		w = 0.178;
		h = 0.090;
                color[] = {0, 0, 0, 1};
        	animTextureNormal   = "";
                animTextureDisabled = "";
        	animTextureOver     = "";
        	animTextureFocused  = "";
                animTexturePressed  = "";
        	animTextureDefault  = "";
		class TextPos
		{
			left = 0.023;
			top = 0.027;
			right = 0.005;
			bottom = 0.005;
		};

	};


	class btnRequest: JWC_Button
        {
		idc = 100112;
		text = "Request Artillery";
		action = "ARTRequest = true; closeDialog 0";
		y = 0.7;
		x = 0.006;
		w = 0.178;
		h = 0.090;
                color[] = {0, 0, 0, 1};
        	animTextureNormal   = "";
                animTextureDisabled = "";
        	animTextureOver     = "";
        	animTextureFocused  = "";
                animTexturePressed  = "";
        	animTextureDefault  = "";
		class TextPos
		{
			left = 0.023;
			top = 0.027;
			right = 0.005;
			bottom = 0.005;
		};

	};

	class btnDummy: JWC_Button
        {
		idc = 100114;
		text = "";
		action = "";
		y = -0.500;
		x = -0.500;
		w = 0.001;
		h = 0.001;
                color[] = {1, 1, 0, 0};
        	animTextureNormal   = "";
                animTextureDisabled = "";
        	animTextureOver     = "";
        	animTextureFocused  = "";
                animTexturePressed  = "";
        	animTextureDefault  = "";
		class TextPos
		{
			left = 0.023;
			top = 0.027;
			right = 0.005;
			bottom = 0.005;
		};

	};


	class lineTop : JWC_Text
	{
		x = 0.001;
		y = 0.035;
		w = 0.522;
		h = 0.001;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {0, 0, 0, 1};
                moving = 1;
		text = "";
	};


	class top : JWC_Text
	{
		x = 0.001;
		y = 0.001;
		w = 0.522;
		h = 0.033;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {1,0.45,0,0.8};
                moving = 1;
		text = "Artillery Field System";
	};


	class lineBottom : JWC_Text
	{
		x = 0.001;
		y = 0.724;
		w = 0.522;
		h = 0.001;
		font = "PuristaSemibold";
		sizeEx = 0.03921;
		colorText[] = {0, 0, 0, 1};
		colorBackground[] = {0, 0, 0, 1};
                moving = 1;
		text = "";
	};


	class bottom : JWC_Text
	{
		x = 0.001;
		y = 0.725;
		w = 0.522;
		h = 0.033;
		font = "PuristaSemibold";
		sizeEx = 0.01521;
		colorText[] = {0.543, 0.5742, 0.4102, 0.80};
		colorBackground[] = {1,0.45,0,0.8};
                moving = 0;
		text = "";
	};


	class mapbg : JWC_Text
	{
		x = 0.011;
		y = 0.052;
		w = 0.502;
		h = 0.501;
		font = "PuristaSemibold";
		sizeEx = 0.01521;
		colorText[] = {0.543, 0.5742, 0.4102, 0.80};
		colorBackground[] = {0,0,0,1};
                moving = 0;
		text = "";
	};


	class map : JWC_Map
        {

		idc = 100115;
		x = 0.012;
		y = 0.054;
		w = 0.50;
		h = 0.5;
		colorBackground[] = {1, 1, 1, 1};
	};


	class Checkbox : JWC_CheckBox
	{
		idc = 100116;
		type = 7;
		style = 2;
  	        x = 0.011;
  	        y = 0.554;
  	        w = 0.503;
                h = 0.025;
		colorText[] = {1, 1, 1, 1};
		color[] = {0, 0, 0, 0};
		colorBackground[] = {0, 0, 1, 0.7};
		colorTextSelect[] = {1, 1, 1, 1};
		colorSelectedBg[] = {0, 0, 0, 1};
		colorSelect[] = {0, 0, 0, 1};
		colorTextDisable[] = {1, 1, 1, 1};
		colorDisable[] = {1, 1, 1, 1};
		font = "PuristaMedium";
		sizeEx = 0.0208333;
		rows = 1;
		columns = 4;
		strings[] = {"40mm","82mm","Smoke","Flares"};
		checked_strings[] = {"40mm","82mm","Smoke","Flares"};
        onCheckBoxesSelChanged = "if (_this select 1 == 0) then {artType = '40mm'}; if (_this select 1 == 1) then {artType = '82mm'}; if (_this select 1 == 2) then {artType = 'SMOKE'}; if (_this select 1 == 3) then {artType = 'FLARES'}";
	};

    class checkEdge : JWC_Text
    {
            x = 0.011;
            y = 0.554;
            w = 0.503;
                h = 0.026;
        font = "PuristaSemibold";
        sizeEx = 0.03921;
        colorText[] = {0, 0, 0, 1};
        colorBackground[] = {0, 0, 0, 1};
                moving = 0;
        text = "";
    };

    class checkbg : JWC_Text
    {
            x = 0.012;
            y = 0.555;
            w = 0.501;
            h = 0.024;
        font = "PuristaSemibold";
        sizeEx = 0.03921;
        colorText[] = {0, 0, 0, 1};
        colorBackground[] = {0.65, 0.65, 0.65, 1};
                moving = 0;
        text = "";
    };

	class RoundsCheckbox : Checkbox
	{
	    idc = 200001;
        x = 0.118;
        y = 0.619;
        w = 0.3;
        h = 0.025;
	    rows = 1;
        columns = 4;
        strings[] = {"1","2","3","4"};
        checked_strings[] = {"1","2","3","4"};
        onCheckBoxesSelChanged = "if (_this select 1 == 0) then {artRounds = 1}; if (_this select 1 == 1) then {artRounds = 2}; if (_this select 1 == 2) then {artRounds = 3}; if (_this select 1 == 3) then {artRounds = 4}";
	};

    class RoundsCheckEdge : JWC_Text
    {
            x = 0.116;
            y = 0.617;
            w = 0.305;
            h = 0.03;
        font = "PuristaSemibold";
        sizeEx = 0.03921;
        colorText[] = {0, 0, 0, 1};
        colorBackground[] = {0, 0, 0, 1};
                moving = 0;
        text = "";
    };

    class RoundsCheckbg : checkbg
    {
            x = 0.117;
            y = 0.618;
            w = 0.303;
            h = 0.027;
    };

	class AreaCheckbox : Checkbox
	{
	    style = ST_CENTER;
	    idc = 2000002;
        x = 0.118;
        y = 0.680;
        w = 0.3;
        h = 0.025;
	    rows = 1;
        columns = 4;
        strings[] = {"50m","100m","150m","200m"};
        checked_strings[] = {"50m","100m","150m","200m"};
        onCheckBoxesSelChanged = "if (_this select 1 == 0) then {artArea = 50}; if (_this select 1 == 1) then {artArea = 100}; if (_this select 1 == 2) then {artArea = 150}; if (_this select 1 == 3) then {artArea = 200}";
	};

    class AreaCheckEdge : JWC_Text
    {
            x = 0.116;
            y = 0.677;
            w = 0.305;
            h = 0.030;
        font = "PuristaSemibold";
        sizeEx = 0.03921;
        colorText[] = {0, 0, 0, 1};
        colorBackground[] = {0, 0, 0, 1};
                moving = 0;
        text = "";
    };

   class AreaCheckbg : checkbg
    {
        x = 0.117;
        y = 0.679;
        w = 0.303;
        h = 0.027;
    };

    class remainingText: JWC_Text
    {
        idc = 200003;
        style = ST_CENTER;
        x = 0.02;
        y = 0.620;
        w = 0.08;
        h = 0.030;
        font = "TahomaB";
        sizeEx = 0.05000;
        colorText[] = {0.8,0,0,0.8};
        colorBackground[] = {0,0,0,0};
                moving = 0;
        text = "36";
    };

    class remainingTitle1: JWC_Text
    {
        idc = 200004;
        style = ST_CENTER;
        x = 0.02;
        y = 0.650;
        w = 0.08;
        h = 0.030;
        font = "TahomaB";
        sizeEx = 0.02000;
        colorText[] = {0,0,0,0.8};
        colorBackground[] = {0,0,0,0};
                moving = 0;
        text = "Rounds";
    };

    class remainingTitle2: JWC_Text
    {
        idc = 200005;
        style = ST_CENTER;
        x = 0.02;
        y = 0.670;
        w = 0.08;
        h = 0.030;
        font = "TahomaB";
        sizeEx = 0.02000;
        colorText[] = {0,0,0,0.8};
        colorBackground[] = {0,0,0,0};
                moving = 0;
        text = "Remaining";
    };

    class roundsTitle : JWC_Text
    {
        idc = 100117;
        style = ST_CENTER;
        x = 0.012;
        y = 0.590;
        w = 0.525;
        h = 0.030;
        font = "TahomaB";
        sizeEx = 0.02000;
        colorText[] = {0,0,0,0.8};
        colorBackground[] = {0,0,0,0};
                moving = 0;
        text = "Number of Rounds per Fire Mission:";
    };

    class spreadTitle : JWC_Text
    {
        idc = 100118;
        style = ST_CENTER;
        x = 0.012;
        y = 0.650;
        w = 0.525;
        h = 0.030;
        font = "TahomaB";
        sizeEx = 0.02000;
        colorText[] = {0,0,0,0.8};
        colorBackground[] = {0,0,0,0};
                moving = 0;
        text = "Spread:";
    };

	class help : JWC_Text
	{
        idc = 100120;
		x = 0.012;
		y = 0.058;
		w = 0.500;
		h = 0.030;
		font = "TahomaB";
		sizeEx = 0.02300;
		colorText[] = {1,1,1,0.8};
		colorBackground[] = {0,0,0,0};
                moving = 0;
		text = "Click on map to designate target position";
	};
};