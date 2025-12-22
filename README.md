# IRIS-Localization-Lab 🌐

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

## 📂 Project Structure

* `LocalizationLab.StrLocalization.cls`: The core logic, containing both the CSP rendering and the server-side ObjectScript.
* `README.md`: Documentation.

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.
