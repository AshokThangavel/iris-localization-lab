Class LocalizationLab.StrLocalization Extends %CSP.Page
{

Parameter Title As STRING [ Final ] = "StrLocalization";

Parameter APPLICATION As STRING = "StrLocalization";

ClassMethod OnRenderScreen()
{
    Set currentNS = $Get(%request.Data("ns",1), $Namespace)
    Set currentDom = $Get(%request.Data("domain",1))
    &html<
    <div id="sidebar">
        <div class="sidebar-header">
            NAMESPACE
            <select class="ns-select" onchange="location.href='?ns='+this.value">
    >
    Do ##class(%SYS.Namespace).ListAll(.nsList)
    Set n = "" For { Set n = $Order(nsList(n)) Quit:n=""
        Set sel = $Select(n=currentNS:"selected", 1:"")
        Write "<option value='"_n_"' "_sel_">"_n_"</option>",!
    }
    &html<
            </select>
            <button class="btn btn-outline" onclick="createNewDomain()">+ New Domain</button>
        </div>
        <div class="domain-list">
    >
    New $Namespace
    Try { Set $Namespace = currentNS
        Set dom = "" For { Set dom = $Order(^IRIS.Msg(dom)) Quit:dom=""
            Set cls = $Select(dom=currentDom:"active", 1:"")
            Write "<a href='?ns="_currentNS_"&domain="_dom_"' class='domain-link "_cls_"'>"_dom_"</a>",!
        }
    } Catch {}
    &html<
        </div>
    </div>

    <div id="main">
       <div class="header-bar">
    <h3 style="margin:0; color:var(--isc-blue);">Localization Manager<span id="headerDomain"></span></h3>
    <div style="display:flex; gap:10px;">
        <input type="file" id="importFile" style="display:none" accept=".xml" onchange="handleFileSelect(this)">
        <button class="btn btn-outline" style="margin-top:0; width:auto;" onclick="document.getElementById('importFile').click()">
            <i class="fa fa-file-import"></i> Import XML
        </button>
        <button class="btn btn-outline" onclick="exportDomain()">
                    <i class="fa fa-file-export"></i> Export
                </button>

                <button class="btn btn-outline" onclick="openSettings(true)">
                    <i class="fa fa-cog"></i>
                </button>
        <button class="btn btn-teal" onclick="toggleAddForm()">+ Add New String</button>
    </div>
</div>

        <div id="addForm">
            <form method="POST" class="form-row">
                <input type="hidden" name="action" value="save">
                <input type="hidden" name="ns" value="#(currentNS)#">

                <div class="form-item">
                    <label>Domain</label>
                    <input type="text" name="newDom" id="newDomField" value="#(currentDom)#" style="width:120px" required>
                </div>

                <div class="form-item">
                    <label>Language (RFC 1766)</label>
                    <select name="newLang">
                        <option value="en">English (en)</option>
                        <option value="en-us">English - US (en-us)</option>
                        <option value="de">German (de)</option>
                        <option value="es">Spanish (es)</option>
                        <option value="fr">French (fr)</option>
                        <option value="it">Italian (it)</option>
                        <option value="ja">Japanese (ja)</option>
                        <option value="ko">Korean (ko)</option>
                        <option value="nl">Dutch (nl)</option>
                        <option value="pt-br">Portuguese - Brazil (pt-br)</option>
                        <option value="ru">Russian (ru)</option>
                        <option value="uk">Ukrainian (uk)</option>
                        <option value="zh-cn">Chinese - Simplified (zh-cn)</option>
                        <option value="zh-tw">Chinese - Traditional (zh-tw)</option>
                    </select>
                </div>

                <div class="form-item">
                    <label>Message ID</label>
                    <input type="text" name="newID" placeholder="Optional" style="width:100px">
                </div>

                <div class="form-item">
                    <label>Text Translation</label>
                    <input type="text" name="newText" style="width:300px" required>
                </div>

                <button type="submit" class="btn btn-teal">Save</button>
            </form>
        </div>


		    <div id="settingsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">Export Configuration</div>
            <div class="form-item" style="flex-direction: column; align-items: flex-start; gap:10px;">
                <label style="font-size: 0.85em;">Target Export Directory</label>
                <input type="text" id="exportDir" placeholder="e.g. C:\InterSystems\Exports\" style="width:100%;">
            </div>
            <div style="margin-top:20px; text-align: right; display: flex; gap: 10px; justify-content: flex-end;">
                <button class="btn btn-outline" onclick="closeSettings()">Cancel</button>
                <button class="btn btn-teal" onclick="saveSettings()">Save & Close</button>
            </div>
        </div>
    </div>

        <div class="scroll-area">
    >
    If (currentDom '= "") {
        New $Namespace
        Try {
            Set $Namespace = currentNS
            Kill ids Set l = ""
            For {
                Set l = $Order(^IRIS.Msg(currentDom, l)) Quit:l=""
                Set i = "" For { Set i = $Order(^IRIS.Msg(currentDom, l, i)) Quit:i=""  Set ids(i)="" }
            }
            Write "<table class='msg-table'><thead><tr><th style='width:140px'>MESSAGE ID</th>"

            Set availableLangs =""
            Set availableLangsArr = []
            For {
                Set availableLangs = $Order(^IRIS.Msg(currentDom, availableLangs))
                Quit:availableLangs=""
                Write "<th>"_availableLangs_"</th>"
                Do availableLangsArr.%Push(availableLangs)
            }
            Write "</tr></thead><tbody>"
            Set i = "" For { Set i = $Order(ids(i)) Quit:i=""
                Write "<tr><td class='id-cell'>"_i_"</td>"
                Set iter = availableLangsArr.%GetIterator()
                While iter.%GetNext(,.curL) {
                    Set val = $Get(^IRIS.Msg(currentDom, curL, i), "")
                    Write "<td>"_$ZConvert(val,"O","HTML")_"</td>"
                }
                Write "</tr>"
            }
            Write "</tbody></table>"
        } Catch ex { Write "Error Loading Data."_ex.BinDisplayString() }
    }
    &html<
        </div>
    </div>
   >
    Quit $$$OK
}

ClassMethod OnPage() As %Status
{
	Do ..OnPageCSPROOT()
	Quit 1
}

ClassMethod OnPageCSPROOT() As %Boolean
{
	Do ..OnPageHTML()
}

ClassMethod OnPageHTML() As %Boolean
{
	Write "<html>",!
	Do ..OnPageHEAD()
	Do ..OnPageBODY()
	Write !,"</html>"
	Return $$$OK
}

ClassMethod OnPageHEAD() As %Boolean
{
	Write "<head>",!
	Write !,"<title>"_..#Title_"</title>",!
    Write "<style>",!
	Do ..LoadCSS()
	Write "</style>",!
	Write "<link rel=""shortcut icon"" href=""portal/ISC_IRIS_icon.ico"">"
	Write " <link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"">",!
	Write "</head>",!
	Write ..HyperEventHead(0,0)
	Return $$$OK
}

ClassMethod OnPageBODY() As %Boolean
{
	Do ..RenderScreen()
	Return $$$OK
}

/// Override this method to render your screens in UI
ClassMethod RenderScreen()
{
	Do ..OnRenderScreen()
	Do ..Scripts()
}

ClassMethod LoadCSS()
{
	Set obj = ##class(%Dictionary.CompiledXData).%OpenId($ClassName()_"||Style")
	Return:(obj = "") $$$OK
	Set xdata = obj.Data
	Set status = ##class(%XML.TextReader).ParseStream(xdata, .textreader)
	While textreader.Read() { If (textreader.NodeType="chars") { Write textreader.Value } }
	Return $$$OK
}

XData Style
{
<data>
	<![CDATA[
:root{--isc-blue:#2b3589;--isc-teal:#18a99e;--border:#dee2e6}body{font-family:sans-serif;display:flex;height:100vh;margin:0;background:#fff;overflow:hidden}#sidebar{width:260px;background:#f8f9fa;border-right:1px solid var(--border);display:flex;flex-direction:column}.sidebar-header{padding:15px;border-bottom:1px solid var(--border);font-size:.8em;font-weight:700;color:#666}.ns-select{width:100%;padding:6px;margin-top:5px;border:1px solid var(--border);border-radius:4px}.domain-list{flex-grow:1;overflow-y:auto}
.domain-link{padding:10px 15px;cursor:pointer;display:block;color:#444;text-decoration:none;border-bottom:1px solid #eee;font-size:.9em}.active{background:#fff;color:var(--isc-blue)!important;font-weight:700;border-left:4px solid var(--isc-blue)}#main{flex-grow:1;display:flex;flex-direction:column}.header-bar{padding:10px 20px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;background:#fff}#addForm{background:#f1f3f5;padding:12px 20px;border-bottom:1px solid var(--border);display:none}
.form-row{display:flex;align-items:center;gap:20px;white-space:nowrap}.form-item{display:flex;align-items:center;gap:8px}.form-item label{font-size:.8em;font-weight:700;color:#444}input,select{padding:5px 8px;border:1px solid var(--border);border-radius:4px;font-size:.9em}.scroll-area{flex-grow:1;padding:20px;overflow:auto}.msg-table{width:100%;border-collapse:collapse;font-size:.82em;table-layout:fixed}.msg-table th{background:#fdfdfd;padding:8px;border:1px solid var(--border);position:sticky;top:0;color:var(--isc-blue);text-align:center}.msg-table td{padding:8px;border:1px solid var(--border);word-wrap:break-word}.id-cell{font-family:monospace;color:var(--isc-teal);background:#fafafa;font-weight:700;width:140px}
.btn{padding:6px 14px;border:none;border-radius:4px;cursor:pointer;font-weight:700;transition:.2s;display:inline-flex;align-items:center;gap:5px}.btn-teal{background:var(--isc-teal);color:#fff}.btn-outline{background:#fff;border:1px solid var(--border);color:#555;font-size:.85em}.btn-outline:hover{background:#eee}.modal{display:none;position:fixed;z-index:1000;left:0;top:0;width:100%;height:100%;background:rgba(0,0,0,.4)}.modal-content{background:#fff;margin:10% auto;padding:20px;border-radius:8px;width:450px;box-shadow:0 4px 12px rgba(0,0,0,.2)}.modal-header{border-bottom:1px solid #eee;padding-bottom:10px;margin-bottom:15px;font-weight:700;color:var(--isc-blue)}
.msg-table tr:nth-child(even) {background: #f2f2f2;}

]]>
	</data>
}

ClassMethod OnPreHTTP() As %Boolean
{
    Set action = $Get(%request.Data("action",1))
    Set ns = $Get(%request.Data("ns",1), $Namespace)
    If (action = "save") {
        Set dom  = $Get(%request.Data("newDom",1))
        Set lang = $Get(%request.Data("newLang",1))
        Set txt  = $Get(%request.Data("newText",1))
        Set id   = $Get(%request.Data("newID",1))
        If (id = "") { Set id = $ZCrc(txt,7) }

        New $Namespace
        Try {
            Set $Namespace = ns
            If (dom'="") && (lang'="") { Set ^IRIS.Msg(dom, $ZConvert(lang,"L"), id) = txt }
        } Catch { }

        Set %response.Redirect = "LocalizationLab.StrLocalization.cls?ns="_ns_"&domain="_dom
        Quit 0
    }
    Quit 1
}

ClassMethod Scripts()
{
    &html<
    <script language="javascript">
    	const urlParams = new URLSearchParams(window.location.search);
    	const MessageDomain = urlParams.get('domain') || "";
    	const currentNS = urlParams.get('ns') || "";
        if (MessageDomain) {
        	document.getElementById('headerDomain').innerHTML = " &gt; " + MessageDomain;
    	}
        function toggleAddForm() {
            var f = document.getElementById('addForm');
            f.style.display = (f.style.display === 'none' || f.style.display === '') ? 'block' : 'none';
        }
        function createNewDomain() {
            document.getElementById('addForm').style.display = 'block';
            document.getElementById('newDomField').value = '';
            document.getElementById('newDomField').focus();
        }
        // Clean URL after load
        if (window.history.replaceState) {
            const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
            window.history.replaceState({path: cleanUrl}, '', cleanUrl);
        }


        function handleFileSelect(input) {
		    const file = input.files[0];
		    if (!file) return;

		    const reader = new FileReader();
		    reader.onload = function(e) {
		        const fileContent = e.target.result;
		        status = #server(..ImportLocalization(fileContent))#;
		        if (status==1){
			        alert("Import successful!");
			        window.location.reload()
		        }
		        else {
			        alert("Import failed: " + status);
		        }
		    };
		    reader.readAsText(file);
		}
        function saveSettings() {
            const dir = document.getElementById('exportDir').value;
            status = #server(..SaveSettings(dir))#;
       		if (status==1){
	       		alert("Saved successful!");
            	closeSettings();
		    }
		    else {
			    alert("Failed to save: " + status);
		    }
        }
        function openSettings() {
            document.getElementById('settingsModal').style.display = 'block';
            document.getElementById('exportDir').value = #server(..GetExportLoc())#;
        }

        function closeSettings() {
            document.getElementById('settingsModal').style.display = 'none';
        }
        function exportDomain() {
            const domainName = MessageDomain;
            const namespace = currentNS;

            if (!domainName) {
                alert("Please select a domain first.");
                return;
            }
            if (!exportDir) {
                alert("Please configure export directory in Settings.");
                toggleSettingsModal(true);
                return;
            }

            // Calls your method with (DomainName, DirectoryPath)
            // Replace 'YourExportMethod' with the actual server-side method name
            let status = #server(..ExportAllLangForDomainList(domainName,namespace))#;

            if (status == 1) {
                alert("Exported " + domainName + " successfully.");
            } else {
                alert("Export failed: " + status);
            }
        }

    </script>
   >
}

ClassMethod ImportLocalization(pData As %String) As %Status
{
	Set status = 1
	Try {
        Set xmlfile = ##class(%Stream.FileCharacter).%New()
        Set xmlfile.Filename = "messages.xml"
        Do xmlfile.Write(pData)
        Set fileName = xmlfile.Filename
   		Set st = xmlfile.%Save()
   		If $$$ISOK(st) {
	   		Set status = ##class(%MessageDictionary).Import(fileName)
	   		If $$$ISOK(status) {
           		Set status =1
        	}
        	Else {
            	Set err = $System.Status.GetErrorText(status)
            	Set status =err
        	}
	   		Do ##class(%File).Delete(fileName)
   		}
   		Else {
	   		Set status= $System.Status.GetErrorText(st)
   		}
    }
    Catch ex {
        Set status = ex.BinDisplayString()
    }
    Return status
}

ClassMethod SaveSettings(pExportDir)
{
    Set defaultDir = $System.Util.ManagerDirectory()
    Set ^zaxk.zpm=pExportDir
	If ##class(%File).DirectoryExists(pExportDir)&&(pExportDir'="") {
		Set ^LocalizationLab.Export("dir") = pExportDir
	}
	Else {
        Set ^LocalizationLab.Export("dir") = defaultDir
		Quit "directory not exist: set to default: "_defaultDir
	}
	Quit $$$OK
}

ClassMethod GetExportLoc() [ CodeMode = expression ]
{
$Get(^LocalizationLab.Export("dir"))
}

ClassMethod ExportAllLangForDomainList(
	pDomain As %String = "",
	pNamespace)
{
	Set status = 1
	Set langArr= ##class(%MessageDictionary).GetLanguages()
	Set dir = ..GetExportLoc()
    If (dir="") {
        Set dir = $System.Util.ManagerDirectory()
    }
	Set timestamp=$Translate($Horolog,",","-")
	New $Namespace
	Try {
		Set $Namespace = pNamespace
		For {
			Set lang=langArr.GetNext(.key)
			Quit:lang=""
            Continue:'$Data(^IRIS.Msg(pDomain,lang))
			Set fileName=##class(%File).NormalizeFilename(dir_"\"_pDomain_"_"_timestamp_"_"_lang_".xml")
			Set status = ##class(%MessageDictionary).ExportDomainList(fileName,pDomain,lang)
		}
	}
	Catch ex{
		Set status = ex.BinDisplayString()
	}
	Quit status
}

}
