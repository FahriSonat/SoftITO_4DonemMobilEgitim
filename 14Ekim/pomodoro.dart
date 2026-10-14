import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: AnaSayfa()));

const List<int> kSecenekler = [10, 5 * 60, 15 * 60, 25 * 60];

String etiket(int saniye) =>
    saniye < 60 ? '$saniye sn (test)' : '${saniye ~/ 60} dk';

// ---------------------------------------------------------------------------
// Ana sayfa
// ---------------------------------------------------------------------------
class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  late final TextEditingController _not;
  int _saniye = 25 * 60;
  bool _goster = true;
  final List<String> _gecmis = [];

  @override
  void initState() {
    super.initState();
    _not = TextEditingController();
  }

  @override
  void dispose() {
    _not.dispose();
    super.dispose();
  }

  Future<void> _ayarlariAc() async {
    final secilen = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (_) => AyarlarSayfasi(mevcut: _saniye)),
    );
    if (!mounted || secilen == null) return;
    setState(() => _saniye = secilen);
  }

  void _seansBitti(int saniye) {
    final not = _not.text.trim();
    setState(() {
      _gecmis.insert(0, '${etiket(saniye)}${not.isEmpty ? '' : ' • $not'}');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Seans kaydedildi ✅')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _ayarlariAc,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Zamanlayıcıyı göster'),
            value: _goster,
            onChanged: (v) => setState(() => _goster = v),
          ),
          if (_goster)
            Pomodoro(saniye: _saniye, onBitti: _seansBitti)
          else
            const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: Text('Zamanlayıcı ağaçtan çıkarıldı')),
            ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              for (final s in kSecenekler)
                ChoiceChip(
                  label: Text(etiket(s)),
                  selected: _saniye == s,
                  onSelected: (_) => setState(() => _saniye = s),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _not,
            decoration: const InputDecoration(
              labelText: 'Bu seansta ne üzerinde çalışıyorsun?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Geçmiş', style: TextStyle(fontWeight: FontWeight.bold)),
          if (_gecmis.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Henüz seans yok'),
            ),
          for (final g in _gecmis)
            ListTile(
              dense: true,
              leading: const Icon(Icons.check_circle_outline),
              title: Text(g),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ayarlar sayfası
// ---------------------------------------------------------------------------
class AyarlarSayfasi extends StatelessWidget {
  final int mevcut;
  const AyarlarSayfasi({super.key, required this.mevcut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Seans süresi'),
          ),
          for (final s in kSecenekler)
            ListTile(
              title: Text(etiket(s)),
              trailing: s == mevcut ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, s),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pomodoro widget
// ---------------------------------------------------------------------------
class Pomodoro extends StatefulWidget {
  final int saniye;
  final void Function(int saniye) onBitti;

  const Pomodoro({super.key, required this.saniye, required this.onBitti});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  Timer? _timer;
  DateTime? _bitis;
  late int _kalan;
  bool _kaydediliyor = false;

  @override
  void initState() {
    super.initState();
    debugPrint('initState');
    WidgetsBinding.instance.addObserver(this);
    _kalan = widget.saniye;
    _anim = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.saniye),
    );
  }

  @override
  void didUpdateWidget(covariant Pomodoro eski) {
    super.didUpdateWidget(eski);
    debugPrint('didUpdateWidget: ${eski.saniye} -> ${widget.saniye}');
    if (eski.saniye != widget.saniye) {
      _durdur();
      _anim.duration = Duration(seconds: widget.saniye);
      _anim.value = 0;
      _kalan = widget.saniye;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('lifecycle: $state');
    if (state == AppLifecycleState.resumed && _bitis != null) {
      _hesapla();
      if (_timer != null) {
        _anim.forward(from: 1 - _kalan / widget.saniye);
      }
    }
  }

  void _hesapla() {
    final ms = _bitis!.difference(DateTime.now()).inMilliseconds;
    final k = (ms / 1000).ceil();
    if (k <= 0) {
      _bitir();
    } else {
      setState(() => _kalan = k);
    }
  }

  Future<void> _bitir() async {
    _durdur();
    _anim.value = 1;
    setState(() {
      _kalan = 0;
      _kaydediliyor = true;
    });

    // Sahte "kaydediliyor" işlemi. Bu sırada widget'ı gizlersen
    // mounted kontrolü sayesinde hata almazsın.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _kaydediliyor = false);
    widget.onBitti(widget.saniye);
  }

  void _baslat() {
    if (_timer != null || _kalan <= 0) return;
    _bitis = DateTime.now().add(Duration(seconds: _kalan));
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _hesapla());
    _anim.forward(from: 1 - _kalan / widget.saniye);
    setState(() {});
  }

  void _duraklat() {
    _durdur();
    setState(() {});
  }

  void _sifirla() {
    _durdur();
    _anim.value = 0;
    setState(() => _kalan = widget.saniye);
  }

  void _durdur() {
    _timer?.cancel();
    _timer = null;
    _bitis = null;
    _anim.stop();
  }

  @override
  void dispose() {
    debugPrint('dispose');
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dk = (_kalan ~/ 60).toString().padLeft(2, '0');
    final sn = (_kalan % 60).toString().padLeft(2, '0');
    final calisiyor = _timer != null;

    return Column(
      children: [
        SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _anim,
                builder: (context, _) => SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: 1 - _anim.value,
                    strokeWidth: 10,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$dk:$sn', style: const TextStyle(fontSize: 48)),
                  if (_kaydediliyor) const Text('Kaydediliyor...'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _kaydediliyor
                  ? null
                  : (calisiyor ? _duraklat : _baslat),
              child: Text(calisiyor ? 'Duraklat' : 'Başlat'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: _kaydediliyor ? null : _sifirla,
              child: const Text('Sıfırla'),
            ),
          ],
        ),
      ],
    );
  }
}