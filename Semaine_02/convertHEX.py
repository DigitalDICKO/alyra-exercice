import sys

def main():
    if len(sys.argv) >= 2:
        hexa = sys.argv[1]
        print(sys.argv[0])
    else:
        hexa ='ERROR'
    print(hexa,' = ', int(hexa,16)
    
if __name__ == '__main__':
    main()
