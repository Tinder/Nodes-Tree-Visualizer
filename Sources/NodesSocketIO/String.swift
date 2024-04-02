//
//  Copyright © 2024 Tinder (Match Group, LLC)
//

#if DEBUG

extension String {

    internal func deletingSuffix(_ suffix: String) -> String {
        hasSuffix(suffix) ? String(dropLast(suffix.count)) : self
    }
}

#endif
