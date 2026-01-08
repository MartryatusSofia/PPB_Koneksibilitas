import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart'; // Import ini untuk tombol mata
import '../controllers/profile_controller.dart';
import '../models/profile_model.dart';
import '../widgets/app_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController _controller = ProfileController();
  UserProfile? _profile;
  bool _isLoading = true;
  int _imageKey = 0; // Cache buster untuk gambar

  // Controllers Edit Text
  final _nameCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await _controller.fetchProfile();
    if (mounted) {
      setState(() {
        _profile = data;
        _isLoading = false;
        if (data != null) {
          _nameCtrl.text = data.name.isNotEmpty ? data.name : data.fullName;
          _subtitleCtrl.text = data.subtitle;
          _aboutCtrl.text = data.about;
        }
        _imageKey++;
      });
    }
  }

  // === FUNGSI MEMBUKA URL (TOMBOL MATA) ===
  Future<void> _openFileUrl(String? url) async {
    if (url != null && url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak dapat membuka file")),
        );
      }
    }
  }

  // === PICKERS ===
  Future<void> _pickAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      _uploadFile(avatar: result.files.first, type: "Avatar");
    }
  }

  Future<void> _pickDocument(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );
    if (result != null) {
      if (type == 'cv') {
        _uploadFile(cv: result.files.first, type: "CV");
      } else {
        _uploadFile(portfolio: result.files.first, type: "Portofolio");
      }
    }
  }

  // === UPLOAD ===
  Future<void> _uploadFile({PlatformFile? avatar, PlatformFile? cv, PlatformFile? portfolio, String type = ""}) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mengupload $type...")));
    
    bool success = await _controller.updateData(
      avatar: avatar,
      cv: cv,
      portfolio: portfolio,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Berhasil mengubah $type!"), backgroundColor: Colors.green)
      );
      _loadData(); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal upload. Pastikan file < 2MB"), backgroundColor: Colors.red)
      );
    }
  }

  // === DIALOG EDIT (Manual Skill) ===
  void _showEditDialog() {
    if (_profile == null) return;
    
    // 1. Ambil skill manual dari Controller (INSTAN, tidak pakai await)
    List<String> masterSkills = _controller.manualSkills;
    List<String> selectedSkills = List.from(_profile!.skills);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Profil"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Nama Tampilan")),
                    TextField(controller: _subtitleCtrl, decoration: const InputDecoration(labelText: "Subtitle")),
                    TextField(controller: _aboutCtrl, decoration: const InputDecoration(labelText: "Tentang Saya"), maxLines: 3),
                    const SizedBox(height: 16),
                    
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Pilih Keterampilan:", style: TextStyle(fontWeight: FontWeight.bold))
                    ),
                    const SizedBox(height: 8),
                    
                    // 2. Tampilkan langsung (Tanpa Loading)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: masterSkills.map((skill) {
                        final isSelected = selectedSkills.contains(skill);
                        return FilterChip(
                          label: Text(skill),
                          selected: isSelected,
                          selectedColor: Colors.blue.shade100,
                          checkmarkColor: Colors.blue,
                          onSelected: (bool selected) {
                            setDialogState(() {
                              if (selected) {
                                selectedSkills.add(skill);
                              } else {
                                selectedSkills.remove(skill);
                              }
                            });
                          },
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: const Text("Batal")
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Menyimpan...")));
                    
                    bool success = await _controller.updateData(
                      name: _nameCtrl.text,
                      subtitle: _subtitleCtrl.text,
                      about: _aboutCtrl.text,
                      skills: selectedSkills,
                    );

                    if (mounted && success) {
                      _loadData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Tersimpan!"), backgroundColor: Colors.green)
                      );
                    }
                  },
                  child: const Text("Simpan"),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Logic Avatar
    String? avatarUrl = _profile?.avatarUrl;
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      avatarUrl = "$avatarUrl?v=$_imageKey"; // Cache buster
    }
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: _showEditDialog,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // === AVATAR ===
            GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    // Cek avatar URL
                    backgroundImage: hasAvatar ? NetworkImage(avatarUrl!) : null,
                    child: !hasAvatar 
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _profile?.name.isNotEmpty == true ? _profile!.name : (_profile?.fullName ?? "User"),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            ),
            Text(
              _profile?.subtitle.isNotEmpty == true ? _profile!.subtitle : "-",
              style: const TextStyle(color: Colors.grey)
            ),
            const SizedBox(height: 20),

            // === ABOUT ===
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tentang Saya", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(_profile?.about.isNotEmpty == true ? _profile!.about : "Belum ada deskripsi."),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // === SKILLS ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(alignment: Alignment.centerLeft, child: Text("Keterampilan", style: TextStyle(fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                children: _profile!.skills.isEmpty 
                ? [const Text("-", style: TextStyle(color: Colors.grey))]
                : _profile!.skills.map((s) => Chip(
                  label: Text(s, style: const TextStyle(color: Colors.blue)),
                  backgroundColor: Colors.blue.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // === DOKUMEN (Dengan Tombol Mata) ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(alignment: Alignment.centerLeft, child: Text("Dokumen", style: TextStyle(fontWeight: FontWeight.bold))),
            ),
            const SizedBox(height: 10),
            // Kirim URL ke widget _buildDocItem
            _buildDocItem("CV", _profile?.cvUrl, () => _pickDocument('cv')),
            _buildDocItem("Portofolio", _profile?.portfolioUrl, () => _pickDocument('portfolio')),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }

  // 3. Update Widget Doc Item dengan Tombol Mata
  Widget _buildDocItem(String title, String? url, VoidCallback onUploadTap) {
    bool hasFile = url != null && url.isNotEmpty;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasFile ? Colors.green.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: hasFile ? Colors.green : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(hasFile ? Icons.check_circle : Icons.upload_file, color: hasFile ? Colors.green : Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: hasFile ? Colors.green : Colors.black)),
                if(hasFile) const Text("File tersedia", style: TextStyle(fontSize: 10, color: Colors.green)),
              ],
            )
          ),
          
          // --- TOMBOL MATA (VIEW) ---
          if (hasFile)
            IconButton(
              icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
              tooltip: "Lihat File",
              onPressed: () => _openFileUrl(url), // Buka URL di browser
            ),

          // Tombol Upload/Ganti
          GestureDetector(
            onTap: onUploadTap,
            child: Text(
              hasFile ? "Ganti" : "Upload", 
              style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    );
  }
}