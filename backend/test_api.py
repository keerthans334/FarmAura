"""
Test script for FarmAura Auto Detect API
=========================================

This script tests the /api/auto-detect-crop endpoint with various scenarios.

Usage:
    python test_api.py

Make sure the Flask server is running before executing this script.
"""

import requests
import json
import sys
from datetime import datetime

# Configuration
BASE_URL = "http://localhost:5001"
HEALTH_ENDPOINT = f"{BASE_URL}/api/health"
AUTO_DETECT_ENDPOINT = f"{BASE_URL}/api/auto-detect-crop"

# Test cases
TEST_CASES = [
    {
        "name": "Jharkhand - Dhanbad - Rice",
        "payload": {
            "state": "Jharkhand",
            "district": "Dhanbad",
            "frequent_grown_crop": "rice",
            "land_size": 2.5,
            "irrigation_type": "rainfed",
            "season": "kharif"
        }
    },
    {
        "name": "Jharkhand - Ranchi - Wheat",
        "payload": {
            "state": "Jharkhand",
            "district": "Ranchi",
            "frequent_grown_crop": "wheat",
            "land_size": 1.0,
            "irrigation_type": "irrigated",
            "season": "rabi"
        }
    },
    {
        "name": "Karnataka - Bangalore - Maize",
        "payload": {
            "state": "Karnataka",
            "district": "Bangalore",
            "frequent_grown_crop": "maize",
            "land_size": 3.0,
            "irrigation_type": "drip",
            "season": "kharif"
        }
    },
    {
        "name": "Maharashtra - Pune - Cotton",
        "payload": {
            "state": "Maharashtra",
            "district": "Pune",
            "frequent_grown_crop": "cotton",
            "land_size": 5.0,
            "irrigation_type": "rainfed"
        }
    },
]


def print_header(text):
    """Print a formatted header"""
    print("\n" + "=" * 80)
    print(f"  {text}")
    print("=" * 80)


def print_section(text):
    """Print a formatted section"""
    print(f"\n--- {text} ---")


def test_health_check():
    """Test the health check endpoint"""
    print_header("Testing Health Check Endpoint")
    
    try:
        response = requests.get(HEALTH_ENDPOINT, timeout=5)
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Health check passed")
            print(f"   Status: {data.get('status')}")
            print(f"   Model loaded: {data.get('model_loaded')}")
            print(f"   Data loaded: {data.get('data_loaded')}")
            print(f"   Timestamp: {data.get('timestamp')}")
            return True
        else:
            print(f"❌ Health check failed with status {response.status_code}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to server. Is it running?")
        print(f"   Expected URL: {BASE_URL}")
        return False
    except Exception as e:
        print(f"❌ Health check error: {str(e)}")
        return False


def test_auto_detect(test_case):
    """Test the auto-detect endpoint with a specific test case"""
    print_section(f"Test Case: {test_case['name']}")
    
    payload = test_case['payload']
    print(f"Request payload:")
    print(json.dumps(payload, indent=2))
    
    try:
        start_time = datetime.now()
        response = requests.post(AUTO_DETECT_ENDPOINT, json=payload, timeout=30)
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        
        print(f"\n⏱️  Response time: {duration:.2f} seconds")
        print(f"📊 Status code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            
            if data.get('status') == 'success':
                print("✅ Request successful")
                
                # Print location
                location = data.get('location', {})
                print(f"\n📍 Location: {location.get('district')}, {location.get('state')}")
                
                # Print recommendations
                recommendations = data.get('recommendations', [])
                print(f"\n🌾 Top {len(recommendations)} Recommendations:")
                
                for i, rec in enumerate(recommendations, 1):
                    print(f"\n   {i}. {rec.get('crop', 'Unknown').upper()}")
                    print(f"      • Model Confidence: {rec.get('model_confidence', 0):.2%}")
                    print(f"      • Suitability: {rec.get('suitability_flag', 'N/A')} ({rec.get('suitability_score', 0):.2f})")
                    print(f"      • Expected Yield: {rec.get('expected_yield_q_per_ha', 0):.1f} q/ha")
                    print(f"      • Expected Profit: ₹{rec.get('expected_profit_inr', 0):,.0f}")
                    print(f"      • Risk Index: {rec.get('risk_index', 0):.2f}")
                    print(f"      • Mandi: {rec.get('mandi_suggestion', 'N/A')}")
                    
                    # Print explanation preview (first 150 chars)
                    explanation = rec.get('farmer_friendly_explanation', '')
                    if explanation:
                        preview = explanation[:150] + "..." if len(explanation) > 150 else explanation
                        print(f"      • Explanation: {preview}")
                
                # Print model input summary
                model_input = data.get('model_input_used', {})
                print(f"\n🔬 Model Input Summary:")
                print(f"      • Temperature: {model_input.get('Temperature', 0):.1f}°C")
                print(f"      • Humidity: {model_input.get('Humidity', 0):.1f}%")
                print(f"      • Rainfall: {model_input.get('Rainfall', 0):.1f} mm")
                print(f"      • pH: {model_input.get('pH', 0):.2f}")
                print(f"      • Nitrogen: {model_input.get('Nitrogen', 0):.1f} kg/ha")
                print(f"      • Phosphorus: {model_input.get('Phosphorus', 0):.1f} kg/ha")
                print(f"      • Potassium: {model_input.get('Potassium', 0):.1f} kg/ha")
                print(f"      • Soil Texture: {model_input.get('SoilTexture', 'N/A')}")
                
                return True
            else:
                print(f"❌ Request failed: {data.get('message', 'Unknown error')}")
                return False
        else:
            print(f"❌ Request failed with status {response.status_code}")
            try:
                error_data = response.json()
                print(f"   Error: {error_data.get('message', 'Unknown error')}")
            except:
                print(f"   Response: {response.text[:200]}")
            return False
            
    except requests.exceptions.Timeout:
        print("❌ Request timed out (>30 seconds)")
        return False
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False


def save_full_response(test_case, response_data):
    """Save full response to a JSON file for inspection"""
    filename = f"test_response_{test_case['name'].replace(' ', '_').replace('-', '').lower()}.json"
    
    try:
        with open(filename, 'w') as f:
            json.dump(response_data, f, indent=2)
        print(f"\n💾 Full response saved to: {filename}")
    except Exception as e:
        print(f"\n⚠️  Could not save response: {str(e)}")


def main():
    """Main test runner"""
    print_header("FarmAura Auto Detect API Test Suite")
    print(f"Base URL: {BASE_URL}")
    print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # Test health check first
    if not test_health_check():
        print("\n❌ Health check failed. Please ensure:")
        print("   1. The Flask server is running (python app.py)")
        print("   2. The server is accessible at", BASE_URL)
        print("   3. All data files are loaded successfully")
        sys.exit(1)
    
    # Run all test cases
    print_header("Running Auto Detect Test Cases")
    
    passed = 0
    failed = 0
    
    for test_case in TEST_CASES:
        success = test_auto_detect(test_case)
        
        if success:
            passed += 1
        else:
            failed += 1
        
        print()  # Blank line between tests
    
    # Summary
    print_header("Test Summary")
    total = passed + failed
    print(f"Total tests: {total}")
    print(f"✅ Passed: {passed}")
    print(f"❌ Failed: {failed}")
    
    if failed == 0:
        print("\n🎉 All tests passed!")
    else:
        print(f"\n⚠️  {failed} test(s) failed. Check the output above for details.")
    
    print("\n" + "=" * 80)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Tests interrupted by user")
        sys.exit(1)
