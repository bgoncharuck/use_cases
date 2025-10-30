# Routing Layer

Abstraction to separate high-level routing logic from UI implementation.

Which allows something like
```Dart
figmaUIVersionJun24 = RoutingLayer<...>(...);
figmaUIVersionOct25 = RoutingLayer<...>(...);
```

Use cases:
- the holy grail for Product Manager ideas, because it allows you to quickly and independently create a separate version with some screens changed
- you can work with a nasty draft UI before Figma UI is ready and approved
