import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/models.dart';
import '../services/api_service.dart';

// Events
abstract class TradesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TradesLoadRequested extends TradesEvent {
  final String login;

  TradesLoadRequested({required this.login});

  @override
  List<Object?> get props => [login];
}

class TradesRefreshRequested extends TradesEvent {
  final String login;

  TradesRefreshRequested({required this.login});

  @override
  List<Object?> get props => [login];
}

// States
abstract class TradesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TradesInitial extends TradesState {}

class TradesLoading extends TradesState {}

class TradesLoaded extends TradesState {
  final List<Trade> trades;
  final double totalProfit;

  TradesLoaded({required this.trades, required this.totalProfit});

  @override
  List<Object?> get props => [trades, totalProfit];
}

class TradesError extends TradesState {
  final String message;

  TradesError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class TradesBloc extends Bloc<TradesEvent, TradesState> {
  final ApiService _apiService;

  TradesBloc({required ApiService apiService})
      : _apiService = apiService,
        super(TradesInitial()) {
    on<TradesLoadRequested>(_onLoadRequested);
    on<TradesRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    TradesLoadRequested event,
    Emitter<TradesState> emit,
  ) async {
    emit(TradesLoading());
    await _loadTrades(event.login, emit);
  }

  Future<void> _onRefreshRequested(
    TradesRefreshRequested event,
    Emitter<TradesState> emit,
  ) async {
    await _loadTrades(event.login, emit);
  }

  Future<void> _loadTrades(String login, Emitter<TradesState> emit) async {
    try {
      final trades = await _apiService.getOpenTrades(login);
      final totalProfit = trades.fold<double>(
        0.0,
        (sum, trade) => sum + trade.profit,
      );
      
      emit(TradesLoaded(trades: trades, totalProfit: totalProfit));
    } catch (e) {
      emit(TradesError(message: e.toString()));
    }
  }
}
