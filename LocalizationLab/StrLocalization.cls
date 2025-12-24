Class LocalizationLab.StrLocalization Extends %CSP.Page
{

Parameter Title As STRING [ Final ] = "StrLocalization";

Parameter APPLICATION As STRING = "StrLocalization";

ClassMethod OnRenderScreen()
{
    Set currentNS = $Get(%request.Data("ns",1), $Namespace)
    Set currentDom = $Get(%request.Data("domain",1))
    Set staticLangs = $ListBuild("DE","EN","EN-US","ES","FR","IT","JA","KO","NL","PT-BR","RU","UK","ZH-CN")

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
    <h3 style="margin:0; color:var(--isc-blue);">Localization Manager</h3>
    <div style="display:flex; gap:10px;">
        <input type="file" id="importFile" style="display:none" accept=".xml" onchange="handleFileSelect(this)">
        <button class="btn btn-outline" style="margin-top:0; width:auto;" onclick="document.getElementById('importFile').click()">
            <i class="fa fa-file-import"></i> Import XML
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

        <div class="scroll-area">
    >
    If (currentDom '= "") {
        New $Namespace
        Try { Set $Namespace = currentNS
            Kill ids Set l = "" For { Set l = $Order(^IRIS.Msg(currentDom, l)) Quit:l=""
                Set i = "" For { Set i = $Order(^IRIS.Msg(currentDom, l, i)) Quit:i=""  Set ids(i)="" }
            }
            Write "<table class='msg-table'><thead><tr><th style='width:140px'>MESSAGE ID</th>"
            For idx=1:1:$ListLength(staticLangs) { Write "<th>"_$ListGet(staticLangs, idx)_"</th>" }
            Write "</tr></thead><tbody>"
            Set i = "" For { Set i = $Order(ids(i)) Quit:i=""
                Write "<tr><td class='id-cell'>"_i_"</td>"
                For idx=1:1:$ListLength(staticLangs) {
                    Set curL = $ZConvert($ListGet(staticLangs, idx), "L")
                    Set val = $Get(^IRIS.Msg(currentDom, curL, i), "")
                    Write "<td>"_$ZConvert(val,"O","HTML")_"</td>"
                }
                Write "</tr>"
            }
            Write "</tbody></table>"
        } Catch { Write "Error Loading Data." }
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
:root{--isc-blue:#2b3589;--isc-teal:#18a99e;--border:#dee2e6}body{font-family:'Segoe UI',sans-serif;display:flex;height:100vh;margin:0;background:#fff;overflow:hidden}#sidebar{width:260px;background:#f8f9fa;border-right:1px solid var(--border);display:flex;flex-direction:column}.sidebar-header{padding:15px;border-bottom:1px solid var(--border);font-size:.8em;font-weight:700;color:#666}.ns-select{width:100%;padding:6px;margin-top:5px;border:1px solid var(--border);border-radius:4px}.domain-list{flex-grow:1;overflow-y:auto}.domain-link{padding:10px 15px;cursor:pointer;display:block;color:#444;text-decoration:none;border-bottom:1px solid #eee;font-size:.9em}.active{background:#fff;color:var(--isc-blue)!important;font-weight:700;border-left:4px solid var(--isc-blue)}#main{flex-grow:1;display:flex;flex-direction:column}.header-bar{padding:10px 20px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;background:#fff}#addForm{background:#f1f3f5;padding:12px 20px;border-bottom:1px solid var(--border);display:none}.form-row{display:flex;align-items:center;gap:20px;white-space:nowrap}.form-item{display:flex;align-items:center;gap:8px}.form-item label{font-size:.8em;font-weight:700;color:#444}input,select{padding:5px 8px;border:1px solid var(--border);border-radius:4px;font-size:.9em}.scroll-area{flex-grow:1;padding:20px;overflow:auto}.msg-table{width:100%;border-collapse:collapse;font-size:.82em;table-layout:fixed}.msg-table th{background:#fdfdfd;padding:8px;border:1px solid var(--border);position:sticky;top:0;color:var(--isc-blue);text-align:center}.msg-table td{padding:8px;border:1px solid var(--border);word-wrap:break-word}.id-cell{font-family:monospace;color:var(--isc-teal);background:#fafafa;font-weight:700;width:140px}.btn{padding:6px 14px;border:none;border-radius:4px;cursor:pointer;font-weight:700;transition:.2s}.btn-teal{background:var(--isc-teal);color:#fff}.btn-outline{background:#fff;border:1px solid var(--border);color:#555;width:100%;margin-top:10px;font-size:.85em}.btn-outline:hover{background:#eee}.btn-toggle{background:#6c757d;color:#fff}
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


    </script>
   >
}

ClassMethod ImportLocalization(pData As %String) As %Status
{
	Set status = 1
	Try {
        Set xmlfile = ##class(%Stream.FileCharacter).%New()
        Set xmlfile.Filename = "messages.xmld"
        Do xmlfile.Write(pData)
        Set fileName = xmlfile.Filename
   		Set st=xmlfile.%Save()
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

}
