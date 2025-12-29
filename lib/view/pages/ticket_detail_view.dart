part of 'pages.dart';

class TicketDetailView extends StatefulWidget {
	final String ticketId;
	final Map<String, dynamic> ticketData;

	const TicketDetailView({
		Key? key,
		required this.ticketId,
		required this.ticketData,
	}) : super(key: key);

	@override
	State<TicketDetailView> createState() => _TicketDetailViewState();
}

class _TicketDetailViewState extends State<TicketDetailView> {
	bool _isDeleting = false;
	Event? _event;
	bool _loadingEvent = false;

	@override
	void initState() {
		super.initState();
		_maybeLoadEvent();
	}

	Future<void> _maybeLoadEvent() async {
		final evtId = widget.ticketData['eventId']?.toString();
		if (evtId == null || evtId.isEmpty) return;
		setState(() => _loadingEvent = true);
		try {
			final snap = await FirebaseDatabase.instance.ref('events/$evtId').get();
			if (snap.exists && snap.value is Map) {
				final map = <String, dynamic>{};
				final raw = snap.value as Map;
				raw.forEach((k, v) => map[k.toString()] = v);
				setState(() {
					_event = Event.fromJson(evtId, map);
				});
			}
		} catch (e) {
			// ignore, keep previous ticketData
		} finally {
			if (mounted) setState(() => _loadingEvent = false);
		}
	}

	Future<void> _confirmAndDelete() async {
		final confirm = await showDialog<bool>(
			context: context,
			builder: (context) => AlertDialog(
				title: const Text('Cancel Ticket'),
				content: const Text('Are you sure you want to cancel this ticket? This action cannot be undone.'),
				actions: [
					TextButton(
						onPressed: () => Navigator.of(context).pop(false),
						child: const Text('No'),
					),
					ElevatedButton(
						onPressed: () => Navigator.of(context).pop(true),
						child: const Text('Yes, cancel'),
					),
				],
			),
		);

		if (confirm != true) return;

		setState(() => _isDeleting = true);

		try {
			final auth = Provider.of<AuthViewModel>(context, listen: false);
			final uid = auth.userId;
			if (uid.isEmpty) throw Exception('User not authenticated');

			final ref = FirebaseDatabase.instance.ref('userTickets/$uid/${widget.ticketId}');
			await ref.remove();

			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					const SnackBar(content: Text('Ticket cancelled'), backgroundColor: Colors.green),
				);
				Navigator.of(context).pop(true);
			}
		} catch (e) {
			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(content: Text('Failed to cancel ticket: $e'), backgroundColor: Colors.red),
				);
				setState(() => _isDeleting = false);
			}
		}
	}

	@override
	Widget build(BuildContext context) {
		final data = widget.ticketData;
		final eventName = _event?.title ?? data['eventName'] ?? '-';
		final description = _event?.description ?? data['description'] ?? '';
		final startDate = _event?.startDate ?? data['startDate'] ?? data['date'] ?? '-';
		final image = _event?.image ?? data['image'] ?? '';
		final kp = _event?.kp ?? data['kp'] ?? '';
		final mandatory = _event?.mandatory ?? data['mandatory'] ?? false;
		final ticketType = data['ticketType'] ?? '-';
		final status = data['status'] ?? '-';
		final price = data['price'] ?? _event?.price ?? 0;

		return Scaffold(
			backgroundColor: Colors.white,
			body: CustomScrollView(
				slivers: [
					SliverAppBar(
						expandedHeight: 250,
						pinned: true,
						leading: IconButton(
							icon: const Icon(Icons.arrow_back, color: Colors.white),
							onPressed: () => Navigator.pop(context),
						),
						title: const Text(
							'Ticket Detail',
							style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
						),
						flexibleSpace: FlexibleSpaceBar(
							background: Stack(
								fit: StackFit.expand,
								children: [
									image.isNotEmpty
											? Image.network(image, fit: BoxFit.contain)
                      // kalau mau mirip sama event detail ganti boxfit jadi cover
											: Container(
													color: Colors.grey.shade300,
													child: const Icon(Icons.image, size: 100, color: Colors.grey),
												),
									Container(
										decoration: BoxDecoration(
											gradient: LinearGradient(
												begin: Alignment.topCenter,
												end: Alignment.bottomCenter,
												colors: [
													Colors.black.withOpacity(0.3),
													Colors.transparent,
												],
											),
										),
									),
								],
							),
						),
					),

					SliverToBoxAdapter(
						child: Padding(
							padding: const EdgeInsets.all(20),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									// category badge (if available)
									if ((_event?.category ?? data['category']) != null && (_event?.category ?? data['category']).toString().isNotEmpty)
										Container(
											padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
											decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
											child: Row(
												mainAxisSize: MainAxisSize.min,
												children: [
													const Icon(Icons.music_note, size: 14),
													const SizedBox(width: 4),
													Text(( _event?.category ?? data['category'])?.toString() ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
												],
											),
										),
									const SizedBox(height: 12),

									// title
									Text(eventName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
									const SizedBox(height: 12),

									// date and room
									Row(
										children: [
											const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
											const SizedBox(width: 6),
											Text(startDate, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
											if ((_event?.room ?? data['room']) != null && (_event?.room ?? data['room']).toString().isNotEmpty) ...[
												const SizedBox(width: 16),
												const Icon(Icons.meeting_room, size: 16, color: Colors.grey),
												const SizedBox(width: 6),
												Text((_event?.room ?? data['room']).toString(), style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
											],
										],
									),
									const SizedBox(height: 24),

									const Text('About Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
									const SizedBox(height: 8),
									Text(description.isNotEmpty ? description : 'No description available', style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5)),
									const SizedBox(height: 24),

									const Text('Available Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
									const SizedBox(height: 16),

									// simple ticket card display
									Container(
										padding: const EdgeInsets.all(16),
										decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
										child: Row(
											children: [
												Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF00D9FF).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.confirmation_number_outlined, color: Color(0xFF00D9FF), size: 24)),
												const SizedBox(width: 12),
												Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(ticketType, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text('Rp. ${_formatPrice(price)}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600))])),
												// no quantity controls here
											],
										),
									),

									const SizedBox(height: 24),

									Row(children: [const Icon(Icons.info, size: 16), const SizedBox(width: 6), Text('Status: $status')]),
									const SizedBox(height: 8),
									Row(children: [const Icon(Icons.badge, size: 16), const SizedBox(width: 6), Text('KP: $kp')]),
									const SizedBox(height: 6),
									Row(children: [const Icon(Icons.warning_amber, size: 16), const SizedBox(width: 6), Text('Mandatory: ${mandatory ? 'Yes' : 'No'}')]),

									const SizedBox(height: 24),

									if (_isDeleting) ...[
										const Center(child: CircularProgressIndicator()),
										const SizedBox(height: 16),
									],

									SizedBox(
										width: double.infinity,
										child: ElevatedButton(
											onPressed: status == 'Upcoming' && !_isDeleting ? _confirmAndDelete : null,
											style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(vertical: 14)),
											child: const Text('Cancel Ticket'),
										),
									),
									const SizedBox(height: 12),
									SizedBox(
										width: double.infinity,
										child: OutlinedButton(onPressed: _isDeleting ? null : () => Navigator.of(context).pop(false), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)), child: const Text('Back')),
									),
								],
							),
						),
					),
				],
			),
		);
	}

	String _formatPrice(dynamic price) {
		final p = (price is int) ? price : int.tryParse(price?.toString() ?? '0') ?? 0;
		return p.toString().replaceAllMapped(
			RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
			(Match m) => '${m[1]}.' ,
		);
	}
}

