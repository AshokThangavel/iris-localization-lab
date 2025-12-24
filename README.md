# IRIS-Localization-Lab

A lightweight, high-performance web interface for managing InterSystems IRIS Localization Globals (`^IRIS.Msg`). This tool provides a professional pivot-style dashboard to manage translations across multiple namespaces and domains with ease.

## ✨ Features

* **Pivot-Table UI**: Displays Message IDs as rows and Languages as columns—offering a much better overview than the standard Management Portal.
* **RFC 1766 Language Support**: Integrated dropdown selection for standard language tags (e.g., `en-us`, `pt-br`, `zh-cn`).
* **Multi-Namespace Switching**: Seamlessly jump between different namespaces to manage localizations globally from a single screen.
* **Inline Entry Form**: A compact, single-line horizontal form for rapid data entry without page jumps.
* **Clean Design**: A neutral gray sidebar with InterSystems-themed (`#2b3589` & `#18a99e`) accents for a modern developer experience.
* **URL Sanitization**: Automatically cleans query parameters from the address bar for a sleek, "Single Page App" feel.
* **Auto-Hashing**: Automatically generates a CRC32 hash for Message IDs if left blank.

## ⚙️ Installation

### Clone the Repository
```bash
git clone https://github.com/AshokThangavel/iris-localization-lab.git
cd iris-localization-lab
````

### Running the Application with Docker

Build and start the app using Docker Compose:

```bash
docker-compose up --build
```

### Stopping the Application

To stop and remove the running containers:

```bash
docker-compose down
```
## 📖 How to Use

Access the url http://localhost:52773/csp/user/LocalizationLab.StrLocalization.cls

### Managing Domains
Select a domain from the **Left Panel** (Neutral Gray) to load the translation matrix. If no domain exists, use the **+ New Domain** button to start a new one.

### Adding Translations
1.  Click the **+Add New String** button.
2.  The horizontal form will appear:
    * **Domain**: Pre-filled with your current selection.
    * **Language**: Select from the RFC 1766 compliant dropdown.
    * **Message ID**: Provide your own or leave blank to auto-generate a hash.
    * **Text**: Enter the localized string.
3.  Click **Save** to update the `^IRIS.Msg` global.

### Exporting a Message Dictionary
1.  **Configure Export Path**: 
    * Click the **Settings** (⚙️) icon in the header.
    * Enter your target directory path (e.g., `C:\InterSystems\Exports\`).
    * Click **Save Setting** to store this as your default path.
2.  **Select & Export**:
    * Select a **Message Domain** from the left-hand sidebar.
    * Click the **Export** button. 
    * The system will export the selected domain's dictionary as an XML file to your saved directory.

### Importing a Message Dictionary
1.  **Select Source**: Click the **Import XML** button in the header bar.
2.  **Choose File**: Select the `.xml` message dictionary file from your local machine.
3.  **Process**: The system will automatically parse the file and update the message grid. Upon success, the page will refresh to display the newly imported strings.


<img width="1919" height="682" alt="image" src="https://github.com/user-attachments/assets/bc16560a-1bc6-4364-b94d-a680e283b05d" />

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.
