# 📜 CHANGELOG for `medibound_ui`
_Last Updated: March 10, 2025_

---

## **[1.0.0] - Initial Release**
### 🔹 Overview:
- First public release of `medibound_ui`, providing reusable graph components for Flutter and FlutterFlow.

### 🔹 Features:
#### **Graph Types:**
- 📊 `ColumnGraph`
- 📈 `LineGraph`
- 📉 `ScatterGraph`
- 🔀 `StepLineGraph`
- ⚡ `FastLineGraph`
- 📏 `HistogramGraph`
- 🟢 `BubbleGraph`

#### **TimeWindow Support:**
- `lastMinute`, `last15Minutes`, `lastHour`, `last24Hours`, `last7Days`, `last30Days`, `pastYear`, `auto`, `none`

#### **Graph Sizes & Constraints:**
- ✅ Supports `GraphSize.half` and `GraphSize.quarter`
- ✅ Allows `VariableType.number` & `VariableType.string`
- ✅ Handles `VariableForm.array` & `VariableForm.singleton`

#### **Graph Processing & Theme Integration:**
- 📌 Auto-aggregates data into time-based buckets
- 🎨 Supports `FlutterFlowTheme` for seamless integration
- 🎯 `TickerType.last` added for displaying latest data points

#### **Optimizations:**
- 🚀 Efficient data aggregation & dynamic time window selection
- 📏 Auto-adjusting `Y-axis` based on highest values
- 🛠 Custom layouts for `HalfSize` and `QuarterSize` views

---

## **[1.1.0] - Upcoming**
### 🔹 Planned Enhancements:
- 📡 **Live Data Support** - Real-time updates for streaming datasets
- 🎭 **New Graph Types** - Candlestick, Donut, and Polar charts
- 🎨 **Theming Enhancements** - More granular FlutterFlowTheme support
- 🏎️ **Performance Boosts** - Lazy loading for large datasets

---

## **How to Upgrade**
Run:
```sh
flutter pub upgrade medibound_ui
